Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6047C8B1B
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjJMQXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjJMQXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:23:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D64D269F
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:22:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0fH4019161;
        Fri, 13 Oct 2023 16:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=PQIlXlWLlHyxxGsSayAzEDIs4yKbqW3/rjE2+QIBDak=;
 b=ciM2iKtzBduNHcK7yMczmNlZB6BnCznMueHuz/Kim7jbuK2z3rWPmarVx/j/jLPuvh5c
 8ZdH8cqEH8vfb5CQU1wFSFpey7JOR3pyEUy8UafglhDuhhvQqdpk3GaD6N9IIiQZ5GUV
 XETlazubbUBG7U2BKmazOop0vvySuWBMpmZXmboKMFQLGb3N1yTQU2BCC9cT+dy+iMqo
 OdH3Tvt9xfvHCP1WKJ36/hOHVUH8t8X1oZC5gLD54n+SPBgmQdPZcv09kbgTtou5+Cdr
 PCuCbXByFIel40uaErQBRpckgqHQlEgPWTeeJp/hv8602DZ3EGcoki38hnCbVkqElTN1 aw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh912ptb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:22:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DEtObm036903;
        Fri, 13 Oct 2023 16:22:12 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0ukc2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:22:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUENqEomZJIQG7hbSyMPUCxTQ+soOxunpEirm71Vu/b4Fc0Zhh6RGtNs+JkCE7ZvphoYyy7/l0FU1w5bgtvPCv/hZdm4T0AUd5/ADIMgBZx3J1eUiYE1mbRwtJb0YH2YzG1wIvGFy+dv5F3+7iXP6WFiMny284P4+FnbrnWRGmkPoqsPDHKLlA7GA19wkxFakfIrxQDdJ+P7rTmeVtT/0ATrD06RZq4Szi6lQzg0I8dDjfY4IUJkz4iQ7WDeIwaaMMEonm8OIzxxkr8HEp9eXLrgpJgOQHv4J+ZKd2Kl/0RKHRabr8P+grgcyIsvoZI1gOXdRktanCKRvgOq+BWHqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQIlXlWLlHyxxGsSayAzEDIs4yKbqW3/rjE2+QIBDak=;
 b=RCHyoVF+17I65yh8ceOQJ9upKJ+8M7nXBJ16KKSa4L+qjeeZCMy221npq1LNZj44lQ2dkgb515r6WAcMyzhO0HC/10qRkDFTK9S13wZ+/GBuKLSW5VLh28E/lrcIk98KYuU8uZA0mQUR3sO6GEVmQ+0JY5HopSTFxu15vmX3j4cTXVF9GgyQNdhYj+pwpwJmSGcTSSdozrryHzMIzNMrfshL3tsVdDdr7LVUMWh62ZyBrZpO+b4Tyx0iozX3zfmIv1sD9jobStBmfSC77DOpyqGqh2jqlrSbfsSSqCogYiTRRqTuwrykCvlDia/pxJINpO18hesz1MatWMvLEXgxEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQIlXlWLlHyxxGsSayAzEDIs4yKbqW3/rjE2+QIBDak=;
 b=CEsNRw6GcpzzyA41TaWQPLbK5hcMhIzCShatqvuhNEYCtQo34hmRTjBEQWqRZebkdXV+2ckuIR41ibvInjM9Te1PiwP2yvderNDM7klQJPiYQabN+hqTSH+SQSAE93wzjZajbzxNs2gOjPRQO7Cske5gSHpAGON3+MZzQKowiYM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4635.namprd10.prod.outlook.com (2603:10b6:806:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.43; Fri, 13 Oct
 2023 16:22:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:22:09 +0000
Message-ID: <ea57ea65-e0a9-426c-8eca-b788c0423aef@oracle.com>
Date:   Fri, 13 Oct 2023 17:22:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/19] vfio/iova_bitmap: Export more API symbols
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-2-joao.m.martins@oracle.com>
 <20231013154349.GW3952@nvidia.com>
 <8d141f1d-bb60-4413-b85b-8e952cceef78@oracle.com>
 <20231013160315.GA3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013160315.GA3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 8893214c-4bcf-494b-243b-08dbcc088cdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ll15GlH+dEYGCCjTON6nHxz2wUoEsfb4HWPEkGCk3SI8/nZ1QZTa1XR6EJRBoxwWtuaMaPDW6Ues0Q8/mxTH8erErlpooU1fm3SsM4vH6R5d2siQahC9MdvJPQr9iwV6g2PGE5DjRjOOo+hZc16WsUnmzyax6rC3uB/033Fs7336Yx9kgWx4YQbNj6OjPD1C4MGY07aw2+prD/4wivQArERh26Ezyk4vWc4JkEKabhOZWo8P0F16MBXTsqirooFRR01ucNQXS3NjV6eTB4GEMe91VheERKN5atf8MqJy9TdxFxkTYsO7SEsUO/8Ses4UBQhcBFS9QF16FB1u+J/qI21fDzIOD7ND4WYPnqmpUhmqRNvl4bNxS+/lfn0Lyn2tqkE1x/IfliOQO59JPcMeFDt05H1tl6YknA40UqXgkGJcOZh6/pnIBVtbqtdiRPDGVXPye99Nt0WzJsBvCVw6rmHM+byGvGS8k5x3XStumwwJmKphajqtWaBP8RbL/BWdAtFlkB8mLeDqc8SNLTy4iVFjetM8gSCyCzD7rWRQPOhyxsgFG7/CDdqRECe9cP6nSj10HtbLjUyUTF70gbs4II6Oau4oUj61v+K15RnfL22EP+mkGe/MHfzK7lAZfyQB92xi+wnwDUgO1kja2b1+kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(54906003)(26005)(36756003)(53546011)(478600001)(6486002)(31696002)(6506007)(86362001)(6512007)(7416002)(66946007)(38100700002)(5660300002)(66556008)(316002)(66476007)(6916009)(41300700001)(4326008)(2906002)(8936002)(2616005)(8676002)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVZNVkVmSVhVcTFlODBqVVpPSDQyWS9IZTlwNFQvOWxvVmNOY3ViQkxDNlZN?=
 =?utf-8?B?RURIS1hWRXJGYmUzbGwxOXdwdDU4c2hET1VNb05qek1IZCtPb09neVBQTFdy?=
 =?utf-8?B?bU5GaklyaU9jQ04ybDEyTWo5cXU3N1hTNHlZUkxLc3lRc2tqbVJJanE3MHpk?=
 =?utf-8?B?SnRpQmJyYWhSYnAxTjYybnVud1R2bFIyeWhDZ1IwQmlyVDJ5VnlrTVhyb0VR?=
 =?utf-8?B?SGlwM1BmTk9TZ1p3UnlDSzRaSmhZTlIzZ0NXNThFQm11ZU5QQ0I3OUFLMHpH?=
 =?utf-8?B?ZUtUTEZSa0Y0TUVxWEs5Q0thWDErOUd4WmRKMzYwQkoyL1RHMTJEUGtyRWd6?=
 =?utf-8?B?OHA4dHJzS1ZJcVcvNEFiUkk3N0RHL1ViTE1Yb2lrM3VSRXR3MlpITVhpZXdi?=
 =?utf-8?B?N2s0cTc4TkR2V3Nod1RIazhiV05JQWljaUJSOG5NeTR4Kzl3ZVBqYi9mMmpU?=
 =?utf-8?B?dExQK3hvMFM4RVllZUxNbmFRbk12ZVlIeXJ4bWt1Sk1LNFJPcmd6YnpvRTRG?=
 =?utf-8?B?cjVJSTNXMUNMU0xyajcyKy9DOHJicGswTlNmcDNJTUZUMitrczNMSFllSGU4?=
 =?utf-8?B?SEMydjV3azV5UEFDNHdQb2dVM2w5eGRDZGk2WkU0LzErcFFVSTdTdUhNd0wv?=
 =?utf-8?B?Q1NFN3RnVGJZVnNxN0JmOXdxdzV2RGdkdDJ6MkUzRWtOSjhUV1FvbjhLTHo5?=
 =?utf-8?B?bVJ0YTFkRlZtOHZaU2lad0Zwb2VGMDZGZmdvQ29jNW1sV0huRVd3V1BkVG1p?=
 =?utf-8?B?KzY2VWxPTmRYVWtQVG5OQVN5Ym9BSVhISGFpVUJZL0tnbForbTNCQ3BqTWZh?=
 =?utf-8?B?dW85QTM5VGNkV1FMcTk5dDlVSEVSMEo4ZEtuMWlscjNobFgzY0t2VHloS2g3?=
 =?utf-8?B?RTM3d2NhaXl5VFl0Ym1kSUlLRHJZRFNRTFdhVk9oZ1ZNaG0wRy9qOVNtcVpL?=
 =?utf-8?B?emx1SG8vNW9PYkdZN0twNmVKTTFrdEhnN29NQitaQmpyY21UR2MxTi95Wk9x?=
 =?utf-8?B?ZkNhRVJmWVZWTkt6elNXTWJjbHhjTGEwQVQxMkFVM1ZJbFhQN09sMlhYVkVZ?=
 =?utf-8?B?RVJ4aUxON3o1Sjg5ZzRGYkRwZU0xVCtnT1FvRm8zUEdkRHI5Tjd2dS9BNW5v?=
 =?utf-8?B?Tlh5YVhTYlMwdE1zbngwSE9VcHo1cUZMUjVOR1N4N0xqbVYxQ2IrZDhyOENx?=
 =?utf-8?B?ZStBTTZ3ZG9ONkpHWlp5ZGZQbUs2TTBud1c1TE5oV0ExejBvVFJ0eVg2cHhV?=
 =?utf-8?B?V3RuZnB3SS83TU1qcU05Ylk5cWlla0V0SkNyR0svU0NvYnlKZmQvaDBncEFB?=
 =?utf-8?B?OUZIVzN6OTRVd0xMLzlNR2NXRXpVN0dtVjZ0RGRyM3Y4SElQM2hWZkZGSDBm?=
 =?utf-8?B?SHNZYlVGakhSUXZUQ1lZTlNuWkFFWVVtWndTYzYrZUtWSHA4RlJ2cFdaUkJu?=
 =?utf-8?B?VTJCMjVNTlBYVmhpbmE3WEFZM3Z4aVoxc0FZMmFQbVRVdWRObmE4UW5rRFNy?=
 =?utf-8?B?dDVpUlZpaXQyMnR5cHFaZ2R6MlFjbDZlRysrbHdjbmZQRHk4THBGaEREbks2?=
 =?utf-8?B?K2lPSEFLL1p0Zkd0YVlVV3orRm1YMTk5LzNteTZJYWxSMVBVVno0VlNlZEll?=
 =?utf-8?B?R3g0bVVpMTJyODM5QkozMHBtSVFlcVBDZkhOZldmQ2RoN2FpU0pna1pqcXVT?=
 =?utf-8?B?V3RYNTYrRkNZNlpUQ0dmQ3QrblAzU2laLytxL0JrVXVxWW5VRFJTcndUS3E5?=
 =?utf-8?B?eUpieGVBRzFYRHExRUNTcWJTeWFEaCtSaFExNnVpTG5VUXAzQkVSY2gxdDJS?=
 =?utf-8?B?YmsvUlllYUMzdFFSM01KWi9sMW1hL2hUM3Y3WUYvaVRZTEtOeVRuWG1Mc21Y?=
 =?utf-8?B?VG5MaFY4czVkNVc1bkQvL041dGIwWVZ0WVdDdExCY2haamZmb0JjYU1BZmZ2?=
 =?utf-8?B?UmIzSVhEa09JSDJKZEJsTU1JWXpDaWcxMDVibW9lWXcvT0gvLytkVEg1bC9N?=
 =?utf-8?B?RjFBRXVkNlpGT0ExYlNPSFZObVd6UmRma0xGM3RqTkNDTUZXQk1lU2JlbmJY?=
 =?utf-8?B?bzVWeFpnVGlyM3dVczBUZnBtdTJVcHJUR1JTRHBKK25UTmlkeFFyakdpOXcr?=
 =?utf-8?B?b1oyNEluVDN2SHBlZFZWWmtBWnUzMkZ2RnJneDR4WUhNMHUwQjcrUWlPelpz?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MFFIUk1lcmd3dlNpWm9lcHdIZ2g5dlFaYzVtQ29wbSsxTlpxVTRjN2tFNU5y?=
 =?utf-8?B?NU5saUJFbWx2QnhmYjlNbDJYVG9tU0wxelpKblNRNGFXUm91aFNjUmlnTy9T?=
 =?utf-8?B?bndLSnNaaVNYdG96Ky9NL1I3dkoxTFFnaG9QTjdLVEJZU21HQWFiNk45SUQx?=
 =?utf-8?B?Y0RkVlQ5eU96ZUdpUlA0LzV1SUdlMkcxYm5VdFB3NG9JSmRET2VqTDEwUUta?=
 =?utf-8?B?aEtycHFZMG1Fblh0TUZEQmNsTnl4eGkrQlFwUlVXYTN0cTgzczhvckhWUktU?=
 =?utf-8?B?MGY0UE9NQ2RRQ0ZkK053TW9IQm1SclVxZGVobWVIL05zTnZDb1JKVEp6S01y?=
 =?utf-8?B?RnBNTWUzbFFBUzNiMjJ6eFprYXYreEF3YkZtak1YVyt6cjcrSkNOR0duZHRx?=
 =?utf-8?B?YXlYMk0xeXR6bEFwdmx6cVFEeERzU3E2bEIxb2l3RzkxekptRjF6Tmg1RDRh?=
 =?utf-8?B?SWp4WXFidklJUkllYy94VURjY0FLOUVkZEExNmhETFhIS3VCWGtGRlFkRm5Q?=
 =?utf-8?B?NnZBUDVpOTNvbW9mT2dzRFJLUmYxbE10SmdQQkl2S0VyWXhLOHFpa292NUVH?=
 =?utf-8?B?WlM2M2FQQnRnSHRsR0o2MHBuZFJaMWhhcHlLQWlIR0c3eE54SEpDR1dUWDNB?=
 =?utf-8?B?d3AvUjVxSzRqYkVDVGVaNXoxY3pQWmNmNFdWWmdSQ1N4OXF5SmZMb1NFbWJr?=
 =?utf-8?B?UmxjOVkxZzA0MFpZT083djh2TzMxeDVhNE5rck8zVlFOeWlMSjB6WVdDWXFZ?=
 =?utf-8?B?QXY1WjRWZURtVWNBWnRhRTlRZ2RhYmJQT0d5MmE1R1ZsWUN3a0hYcGFWKzhG?=
 =?utf-8?B?c3hyYVBFWHVidmdIUkVzRW1lRHZhYUdlRDcydzNtNnNtS3duQmRJeHd6VjMw?=
 =?utf-8?B?NjJnV0s0TlA3cy9qMktWLzN0dFc4TndNK2xocGIwZkYwd1FlMXpNaWlsWWVq?=
 =?utf-8?B?ZXJPY0duOUVFblRKZ3l2NWNsb0VwWFJPWkEwbVIzSmpKd29tYlM2OWZPTWda?=
 =?utf-8?B?NlhtR2FhZ0NTaWsyS2xXWkx5RGxRTGUvelNMN2psWUdSMzA1Y2pwdTAzN3l5?=
 =?utf-8?B?MWJUSFNyZmEwbTY5QmZMdUdkcUpyUVJ5TzV5SG9BWVYwdDBCTnhYcllrZld5?=
 =?utf-8?B?TUFZa3ptUmZVZnE0WDFtd2JVYmdIZ3l4OEVsLzk0cUJ2SW5nQjJwTVIyaFp2?=
 =?utf-8?B?WDhjWjQ3SXIxMXJVY3UrLzdtbVdlNXdUSnEraWllRXd1YjZiUEU0TytKM0xE?=
 =?utf-8?B?THN0ZGFXR3UzOHVMMy9GeHRJOFczZjY0bGl6Q0IzYTcyeWxqTmlDcEgxc3VG?=
 =?utf-8?B?QUt3R2tlYS8ydExJeUU1R09odHZjekMreDA4ekJ1bTNwc1lMK2Q0NWhCSm1q?=
 =?utf-8?B?TXFPbVF5bXQ3MGV5ZTZCVjIrT0VyR3hoVmFQc1hidDhzdzd1ejA5TVRqR0Nr?=
 =?utf-8?Q?VxQFxZED?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8893214c-4bcf-494b-243b-08dbcc088cdc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:22:09.9744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACOa+V5GxGXnP7fv0lGEaADLdYPKDwuybcb5P24lMpyRKvP8cztsCBwxcqe+f2JLXvXwTKvAhNHUmPubd2aEL176ZKfz1I37XbUELyMi4fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4635
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130139
X-Proofpoint-GUID: yQPx8YyPVE45mxp260iYDYsCZrlva9fR
X-Proofpoint-ORIG-GUID: yQPx8YyPVE45mxp260iYDYsCZrlva9fR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/10/2023 17:03, Jason Gunthorpe wrote:
> On Fri, Oct 13, 2023 at 04:57:53PM +0100, Joao Martins wrote:
>> On 13/10/2023 16:43, Jason Gunthorpe wrote:
>>> On Sat, Sep 23, 2023 at 02:24:53AM +0100, Joao Martins wrote:
>>>> In preparation to move iova_bitmap into iommufd, export the rest of API
>>>> symbols that will be used in what could be used by modules, namely:
>>>>
>>>> 	iova_bitmap_alloc
>>>> 	iova_bitmap_free
>>>> 	iova_bitmap_for_each
>>>>
>>>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> ---
>>>>  drivers/vfio/iova_bitmap.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>
>>> All iommufd symbols should be exported more like:
>>>
>>> drivers/iommu/iommufd/device.c:EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);
>>>
>>> Including these. So please fix them all here too
>>
>> OK, Provided your comment on the next patch to move this into IOMMUFD.
>>
>> The IOMMU core didn't exported symbols that way, so I adhered to the style in-use.
> 
> Well, this commit message says "move iova_bitmap into iommufd" :)

:( It should have said 'into iommu core' just like the next patch which says
"vfio: Move iova_bitmap into iommu core". let me fix that, but well no point now
if the idea is to actually move to iommufd
