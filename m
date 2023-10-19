Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171517D057B
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346738AbjJSXsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346677AbjJSXsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:48:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB73112;
        Thu, 19 Oct 2023 16:47:52 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JKxZhn004152;
        Thu, 19 Oct 2023 23:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rPTa6NQ+hX1KxQxsAE0aQUtGs+ax0iqaD1N/STbDUMw=;
 b=VLIWk6QS59GDtsKApYyJ8CtQnTc8taYnpXdmikxE8Y0vVNsGyelHBc+GmzoRw9MKmk7s
 AECXWWSoAq+wNw05ZlbPanqvRVCad9NX7AVOBjVtaV23Ba4F/1GteYCCaGpA0Spk/Qs4
 7Q43IaPWMEqbXjxsydTO6ChTDDQTIMcnVRbWP8+IFQQPkbS3xgi9tL+cH2AqiK3haNlu
 zUc8yqqoQHf3z7ugdC2ECiR4xDWDsdLzwQibsvc4GtjcKo2XhyPx90a6AjZkGvFpF3wS
 MCF9mMmdDl1UtC5Ws5O7JHcYzt9x2XhYmrvqT0cTBAvpARsLb85fI69xIIML6ZzLWhT5 xA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwdg6nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 23:47:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JNVNe6014006;
        Thu, 19 Oct 2023 23:47:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwemvn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 23:47:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVrTUq0ePmkzqWbbkG90wzaFjPP0hJi6otTtdw2iq31gMwJXXIUTftBJA0603uMOzBsO6FYoupGIqnKLXdjiTzDTKU5mgdfXVM9qOI55SKVQNYdZvT1iU6iomeNurLEX2EjbfNqEZ8IM5nK9w6Lt8is1uKmmYP9wj5bv5qD72JQ3v/wyaP+uP45STwVFHw0ENH6YaWbti5cIkg5Ya8a69b43icZshvGa07k6YyKh8gEq1kV723fGkTgkXma3dPEbw699iTVommnaQvjCCvL/rqvXMrVGLOwvq2ueXJk5EXWRZGLTXUBQ0b7oAV/IIVt1Tf1fi7wk4e1JvXpd+ibC2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPTa6NQ+hX1KxQxsAE0aQUtGs+ax0iqaD1N/STbDUMw=;
 b=c6gi5hMHH6H5zMk+mRqOYy3YGBivYkGPIf8dLrpd3TPyXHD5ZlevbxMKHleSALI2tXbxusuqnYj2UCAiU/E+Qs5cKTPT84lYydqHhXTLVqS1RFO6Ul646bRz2rOw+3DGezlg6L3eIH8AozHUyHSNcjDP4FoSYcCshkNnNdH3+9V0eBSUCKbizb9/5BakWbXBFcDWYYv0h2vVoQZGPkbtAoWz75iMCTyLqXX4ntNdiaXIyvNbWEjmE6FdHG9ZbutbIiuuGs3a07rrswm7iPrHbUfsYXkE6fX8I9YAlywUyn3AaHIxAk87XNUBTHO5mszqxSsMphuw8l/uxQuXHDBUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPTa6NQ+hX1KxQxsAE0aQUtGs+ax0iqaD1N/STbDUMw=;
 b=bw7RlDARVo8GFfnOumvYYlM9VTmj4J9ALvdndgOMgcnEgjtlly/dz+06rNAb+cFhPA9GmFnzAZ8PPc5LO9Rm1pYDl6ni+oxltHaXbzTH7JZ7zAC0fB3AirYSO67b2wmvyqzwUCnGkJ8Ijlna05LYIRO5wQUajpdqQ4kFVA1xL4I=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by BN0PR10MB4871.namprd10.prod.outlook.com (2603:10b6:408:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Thu, 19 Oct
 2023 23:47:38 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::5393:c70f:cefa:91c1]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::5393:c70f:cefa:91c1%3]) with mapi id 15.20.6886.034; Thu, 19 Oct 2023
 23:47:38 +0000
Message-ID: <94caea55-b399-40c2-98ef-d435c228808f@oracle.com>
Date:   Thu, 19 Oct 2023 16:47:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v4 00/16] vdpa: Add support for vq descriptor
 mappings
Content-Language: en-US
To:     Dragos Tatulea <dtatulea@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0165.namprd02.prod.outlook.com
 (2603:10b6:5:332::32) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|BN0PR10MB4871:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e51cf7a-d54f-42f7-5318-08dbd0fdc64c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzLTXdTLjtITG0d9/gNKCSH/354A+CaqVKdSdayUmBiKilkWmxhZltlO7nwNmPmyi6buwoNhHP5aKB+9AXYfgnHxLTuQD0OqP4DtEy+8fKbxabjVfpASLTfpxL8Ya+KpSCg7sd9I9NYK4iaRr56fQ+oyyj7xQIeMOYjBgoapj0233lK/1yYVrOLvw/RVbpBZv4P9Kd1LCGB4Z9IL6L6ntXNyXkK7gTDfPqA0aHibFnzVDw+DDDqA/fxDYRIg5Zh92aMpCm1JuGiFQPwiOuLp7IwL+e5FEDAVKyQM1Tym0amIkCKrk15AI1iDPpmZQFK4fF3bbb1UpdpzbnA7Z7JMT4mQG9fdToEI7Lg8ZVPrgJHNn0z1VE6cZoT+97DD05wG34Pgfp07LBtizyd3jzRCMfIBax+pzpDE2DxQfrNVZ/ME9PWkEDwiIuqsXubFrFmSnaBzgabLnAqH5kDcsKqIUzvBQNYS+ILhip6b7wztlJW0NvZIcDP9G/T/frfv0FFBEshjAWORZ3btuGI5obU4ibLOwrtIuRSENMtvlyuvhJBl1fC1dnudHg2k9O6qxh6cU0aMA0d/b6lNcHvrWSFjzzP/GfdrNQEJQWXFgIxl77QTj/TqT/GHLrerZ/xZ9ojbshvrXWyK+yLd5RuFUIYLwR9PKQ9RNfCfVGG9PntdvRib1+bHChWyIqGW8I+HeKYZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(346002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(2906002)(36916002)(6512007)(6666004)(53546011)(2616005)(6506007)(31696002)(110136005)(316002)(478600001)(66476007)(66556008)(86362001)(66946007)(966005)(6486002)(83380400001)(38100700002)(54906003)(5660300002)(26005)(7416002)(8936002)(4326008)(8676002)(36756003)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0tPVWJmZkZFRTJhZmF3b3ZQdC9zeExBcmxOYlBrM24yUjZQMi83U0pVbGQ5?=
 =?utf-8?B?cThaU1VjZGc1OW5ad3NSdXQ1SjRjZ2JpNS9KZkIwaUtIR29BNk42bDBhMmtL?=
 =?utf-8?B?eDZmOEVoSGZXOFJmLzhsQ3B2aGhoZXJ3UkRWRjBRY2swQ0dxK1RGdHIreEto?=
 =?utf-8?B?N0g2YVk3MlRuTnJtalpNV01neDBZS0QvTThWWDZkMExzb0RPWEd3YXhpTmlB?=
 =?utf-8?B?b0pCTE5Rd1ZSVC80MEp0ZWVKSzdHNVRDN2ZkSzlONDFyMXF6SmgzL3ZBMTFD?=
 =?utf-8?B?SzRXMWlTKzg4YjR4NjBka1MrckZZN2xuMVFUVEVoYlBlYkhaOUlhTUFIcFE4?=
 =?utf-8?B?YTh6anZLc0hxdUhEK05zdndqdEc1WEh2eElrdEJzSnhTYmtSVnRyeUhBQ2RU?=
 =?utf-8?B?S1hydWhKY1RYVXV6N0M2TEdqVlU1UEdZbWRpOUdrdTRwOXpTUlF2VjBTbzBx?=
 =?utf-8?B?cXJkUWMycVQ1RW5TYVlHVzBiMFVGdlVzZkRHdnQ2MmhSVDQyQk9XN2drbkMx?=
 =?utf-8?B?RnErM1dOS2EwVzJuVnh4Y29DSUtyMjVsZ2kwZXZVUjJibkRpcnZqV2JaNlhk?=
 =?utf-8?B?dTg5TTVsZ3N3UUp5dGVMeG5Qd3ZNZE9kRk52MktDK0hyMmdCZWhJQ1p2YjZo?=
 =?utf-8?B?WEo2VFc1bGJiRC9KVzc3Zlc5TEJmTVRlT0xOdmZVS2QxRzV2QjhNZ3ViMkVE?=
 =?utf-8?B?czFYOEpTMkZRYzdpeGpsZVd3dGVnbUp0RE5sTU9FaUJTdTdEUVZ2YWhTUFYy?=
 =?utf-8?B?akUxUGZidVJzU2k3Nk1SQ3NQWGNCSVV0Z2N4UkdvNUc1RXdyQi9VcVZweWlE?=
 =?utf-8?B?VGkrcjZTM0ZrKzdEcVNSV2dMcTFjOTFwUWxYNitXQzh1WXBFQWZ6NmRpM0JL?=
 =?utf-8?B?aVE0dE82alJYS3QwVEMxMmFvVXNBdVptQWpXZTYvaUJNcmgvMTZlMkxjcmN5?=
 =?utf-8?B?dVhscmVwMVZqb1ZHNGpad2NzcTE5ZzZDSzVHR2VpaFczUm1FWjdRUDA5UElX?=
 =?utf-8?B?L1R2cjBwSE5uRXRBdHRpM3ZHVERaM0tiZy9UN1JxMTN5UFlVQVdYam0vUWU5?=
 =?utf-8?B?OVpPa2F0cVUwaDJDc2dIaGlWdy95N0NQKysyR2E0NGdHSlF4Tm9pWmJMTEJC?=
 =?utf-8?B?M3ptajJCWS94ZlZzZ3ZJa0VPMTBXMnRMMmpsWEhyaytVZVdDWnl0eVlWR2No?=
 =?utf-8?B?YU5TaXlBa3dEMHpDSUJNNlNOQm5WaUlGSWdzbElBMlVKQ04rZjJDaSt1ZDd0?=
 =?utf-8?B?Z2ZzTE9ub2NjdWxzTTNVQnhnai9keU02T1NQZm12Wmw5anZKNzVZbnpNbWZx?=
 =?utf-8?B?YU5jelpKcXA4R3hiMUZmdWhtbFVqaHVUcGY4WVNzT3JCUjEvNW1USFg0NE1z?=
 =?utf-8?B?RmdZMWNGSDd2NlVXMFhYSUYveVFVVlNnR2JNcm1renVUcXBQbldUN092emsz?=
 =?utf-8?B?bG1VQTcvWkd0VW4rRDBYWVVETzhhdytnVStpdjR0T2xmZkMzSzZ6YWczOVFU?=
 =?utf-8?B?b0EraDNHR2hKMXlBb0k1dXJlQjZYZXFZL2c4ZnFsRW1uZFpDbDlYVitHVW5y?=
 =?utf-8?B?d0Z1a003L0k3V0FTM2J3dmNmNFpjV1dGSjlSaXE0NUdhWDBhdytYTHRLeTFN?=
 =?utf-8?B?cjBZVzB4cm1veDZrcG8vTjJObWdlMmlmVlozajJJWlNoSk5rV21CV28yYUdX?=
 =?utf-8?B?SVdORHVFM1lHd2toRE9uMzV3Rzd1V0V4d0FyRFc2VGpSVGkxVmpTZWJjVUxU?=
 =?utf-8?B?WnN0Ti9vdDQ0M1N6bWw4bHprVjhCN2czcFE1bllKbkgwa2NCVnpITzA2U2Va?=
 =?utf-8?B?TXFXSEZXbEZ0RW9yYjB2UTJNRzhPeTBqNEtTNjR1akVmUFpOZUtLUlVZMmt3?=
 =?utf-8?B?bkxRZGc1cDRLWFpPNFEvWStiVFBUdFYrb296TXp6R1Y1dzg0WVN4eTdCSFY0?=
 =?utf-8?B?VzVQUEQ2SlNQTGdlZlhCYkQwcVZKaGpzUGFsS012cnFIbTgyZHhubmVVSmc2?=
 =?utf-8?B?aGtLS045aXNROWgrNGxuZEt0RURCYkloSlVabitTODRpTVZpazI2NEZVWHdC?=
 =?utf-8?B?SVNiZmlzM3pvM3lyQTFDVG1Ha0g1SENBRFc5UlQ4OTJkemdlemRMZFlKbTVX?=
 =?utf-8?Q?oqF05fQ5N2J+ye2Lht0Egq53X?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SDZweWh3QURCZHFaTUlDaHlwUTcwNVg1a3JwWXltSDBtdHJuVm1EUEhtZm5j?=
 =?utf-8?B?cVJiVmsvYTZlMDBiQllFTURaRDJydjQ4cWRSRUFlMDhYcG5TZ2lxd2NPRmpp?=
 =?utf-8?B?bzNNV0N0bTcwemtnSXZiWEk0ZnhNcUVCKzRGYWd5SUFPS3ZqYWpxcmUwMURD?=
 =?utf-8?B?cVdSQlNaTDdKLzR1WUxnLzBzbzI5UTBvSW5qRUl0cjFNU3JERXZpU3QwNVRE?=
 =?utf-8?B?TFQydktVbG4zYmpCclJPUHpZSUhQeE5MZkNUWGhXTTlhOU9hbWhqVU1ZR3o5?=
 =?utf-8?B?WEQwZThjWUNUSG9FQXRBeU15b2xqS2NxZjlYT0JHSTJMS0cwbU53TmJlR1dV?=
 =?utf-8?B?ZWQ1a0xKc2RBZjg2bm9DM1F5SVpYZ0FvT2FVUy9zU3Q4Sk9jclg2bDMrckhu?=
 =?utf-8?B?bjU1VldNc3lUNEZRQUJ4YkZRMTBpN1hLWm95V090TllpWnhQQUYvS09XUGVp?=
 =?utf-8?B?KzZPakxRN2JXRWFDaEFIdmNmNTVyaGRVMnovamtzcHpkZXRNVDB5U1g0OHkw?=
 =?utf-8?B?a3VLR0VxbkhCOWxuWGJHcHJhZmhqMUlraUt3S1NPb080L3hpRXlNaitRK1dp?=
 =?utf-8?B?cnFGWldCZEgxbG42aWoxd2pRSDV3Vmw1aWNxN1ZjQ3RZOXp3RHRpNHdXbUFU?=
 =?utf-8?B?ejQxYW8wRFVlVGZaTGFjSEc3SGNVTzBXekNPSjFxaFV6L08wTlQxVjg3ZXU4?=
 =?utf-8?B?aUt4Q1pURUtqNWpGdHgrVHVHQzMxbWtqKytncnhkRmNKNWlDWkdsM1pEV2kx?=
 =?utf-8?B?cU9hMlNrbVlONm4zS0c3a3F4aW0zODdIVituMkVUL1JnTUdON0tSMUdIUTNi?=
 =?utf-8?B?NnZSbmxoaVMvQm9WZ0RPUklXWURsZWZnOXZuVUhTOEVqZ2sxYXdydmRaaE5a?=
 =?utf-8?B?L1JFSHdlSlEzQnk2bldrbThFbUZKM1pxMTF2SVA5bFMybVFpN2hXZ2xqcldO?=
 =?utf-8?B?Y3BpK3RBQnlsejZPVkN2R2RHZXYwYzBQMWpJSzc1cDdwQXNZN0lPQmJsZ2Zz?=
 =?utf-8?B?VUlYWlVsY1BtOExIazB6ZG5neHgvaGVhRXdOZVlxY0dOeFNlS0dLVjVrZ2N6?=
 =?utf-8?B?K2NSeWJyVW00T0VUWDlIWWpBUllLYkZRb0VsZnlkU0JRYzNrVURiV2hKWFBH?=
 =?utf-8?B?MVROdk9nT2txbjVNSEJubm91K1NDeUFrU0NMY2d3U1ZBMXFueThGL0RZb0FI?=
 =?utf-8?B?UThydGxIT1ZBODdqTDZ5WnBLWiszSUNvV0tPaXUvbWVTQUNCeW80UU14UjhE?=
 =?utf-8?B?NEZBRlNWTFI4bjRjWlAwNlpnWnhBSHd5RDdGNHVhL3NxUGtudVpVbjd1R0VB?=
 =?utf-8?Q?lx2La/E3YzMN8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e51cf7a-d54f-42f7-5318-08dbd0fdc64c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 23:47:37.7098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8/xoR/+alNm+WUCF2fQ39+UxdaMPWY4pdGFXjMuJ0h4dUrR9z+yh/m7UbeWjjilQI6wuOs07QJEkMcdeL3lhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_21,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310190200
X-Proofpoint-ORIG-GUID: qB_jafMqs5WewIJV9KSF9m0YOcB0NS5n
X-Proofpoint-GUID: qB_jafMqs5WewIJV9KSF9m0YOcB0NS5n
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For patches 05-16:

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Tested-by: Si-Wei Liu <si-wei.liu@oracle.com>

Thanks for the fixes!

On 10/18/2023 10:14 AM, Dragos Tatulea wrote:
> This patch series adds support for vq descriptor table mappings which
> are used to improve vdpa live migration downtime. The improvement comes
> from using smaller mappings which take less time to create and destroy
> in hw.
>
> The first part adds the vdpa core changes from Si-Wei [0].
>
> The second part adds support in mlx5_vdpa:
> - Refactor the mr code to be able to cleanly add descriptor mappings.
> - Add hardware descriptor mr support.
> - Properly update iotlb for cvq during ASID switch.
>
> Changes in v4:
>
> - Improved the handling of empty iotlbs. See mlx5_vdpa_change_map
>    section in patch "12/16 vdpa/mlx5: Improve mr upate flow".
> - Fixed a invalid usage of desc_group_mkey hw vq field when the
>    capability is not there. See patch
>    "15/16 vdpa/mlx5: Enable hw support for vq descriptor map".
>
> Changes in v3:
>
> - dup_iotlb now checks for src == dst case and returns an error.
> - Renamed iotlb parameter in dup_iotlb to dst.
> - Removed a redundant check of the asid value.
> - Fixed a commit message.
> - mx5_ifc.h patch has been applied to mlx5-vhost tree. When applying
>    this series please pull from that tree first.
>
> Changes in v2:
>
> - The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
>    was split off into two patches to avoid merge conflicts into the tree
>    of Linus.
>
>    The first patch contains only changes for mlx5_ifc.h. This must be
>    applied into the mlx5-vdpa tree [1] first. Once this patch is applied
>    on mlx5-vdpa, the change has to be pulled fom mlx5-vdpa into the vhost
>    tree and only then the remaining patches can be applied.
>
> [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
>
> Dragos Tatulea (13):
>    vdpa/mlx5: Expose descriptor group mkey hw capability
>    vdpa/mlx5: Create helper function for dma mappings
>    vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
>    vdpa/mlx5: Take cvq iotlb lock during refresh
>    vdpa/mlx5: Collapse "dvq" mr add/delete functions
>    vdpa/mlx5: Rename mr destroy functions
>    vdpa/mlx5: Allow creation/deletion of any given mr struct
>    vdpa/mlx5: Move mr mutex out of mr struct
>    vdpa/mlx5: Improve mr update flow
>    vdpa/mlx5: Introduce mr for vq descriptor
>    vdpa/mlx5: Enable hw support for vq descriptor mapping
>    vdpa/mlx5: Make iotlb helper functions more generic
>    vdpa/mlx5: Update cvq iotlb mapping on ASID change
>
> Si-Wei Liu (3):
>    vdpa: introduce dedicated descriptor group for virtqueue
>    vhost-vdpa: introduce descriptor group backend feature
>    vhost-vdpa: uAPI to get dedicated descriptor group id
>
>   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
>   drivers/vdpa/mlx5/core/mr.c        | 194 ++++++++++++++++-------------
>   drivers/vdpa/mlx5/core/resources.c |   6 +-
>   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 105 +++++++++++-----
>   drivers/vhost/vdpa.c               |  27 ++++
>   include/linux/mlx5/mlx5_ifc.h      |   8 +-
>   include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
>   include/linux/vdpa.h               |  11 ++
>   include/uapi/linux/vhost.h         |   8 ++
>   include/uapi/linux/vhost_types.h   |   5 +
>   10 files changed, 272 insertions(+), 130 deletions(-)
>

