Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACFD6993D6
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 13:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBPMEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 07:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjBPMEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 07:04:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CC459C7
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 04:04:48 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G8Fr07029177;
        Thu, 16 Feb 2023 12:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=B0NNh/HJboUH4m5AVirtwllXSICSALlhrKjrAMej6h4=;
 b=g0WaKBalwvfAVrwJTVbAUk5eJEQ4sgtiklmRV+yiwAx38LOO5i5T/elzot9N/hF6xdFm
 7xPo0lylUBRxh71SpRLNrrTNLpGivgNrhOMsdLJ368VXBWZGEe+AkG4vnN+807Z/djTg
 0if65/1I4ndteaG7TPL5LvXQjlORFzWEGw+FH+deMMY+QDVhF5iKwebxTEezISqMI80x
 x7ht4U2wTzJURdjte8EqvEUmgJNWTkWsI6FHKX3g8yyeYLTXx2bCKS2j0rV6pysH20oE
 Ddxp1B3fiVoiU1H0pL3SI05867VCe2ACBxvWKkkPO5bGFlJ4j9mcjyaxZN8SC6WqUjJt ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2wa2yg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 12:04:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31GA6vV5015122;
        Thu, 16 Feb 2023 12:04:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8h2qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 12:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuHEv+9TzxzsgAJ+3zmLGWoQARoACaA8At8J3KRWYFm0Jy/bG4DT8QRN292RVMPe4SpxT3lc35+g0hrij+/k6FMafKtHHyM/Mib6kdYnmgYab0L8MLl0meDjPWgX22cG2966XGodqGizdG921hYC/gQv2zS8syrpi+BvOhheFHQgDCAWf3OwD45mQAu6etFh5tMAY9G+QhZBhIIOqfwvDww1LpzeVct1rK7XyWjj0sDaqEiLZVx8jsazQIZwDCPJvQX52Hem4Bw1BvXx1lO1kJxAMiZiRL8K+GLWn9uM5rDwksOJ27/QoBV83Zo2uXl4MoroO9w9sJUwosurR+mo+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0NNh/HJboUH4m5AVirtwllXSICSALlhrKjrAMej6h4=;
 b=i/uOaGcDOX2YJJfdI9IwBdq0S0aONJi+0kwPNXEW0BgSIDTG8fE3dDLXbg3lqENINhgVowX1+lWTsiEIlBH42INFHVqxmLai7gZ12eVbOIk48G0mWb/V+o0Vq804eXnOA4UdRwropGeFFUmwa0+rJy472hL6m4XIpiHLsCjV5zzDvE7ECvtGDWxDx7YzZu/iwvDrCGC8WdZHxSu6SBvJB0PBye+TL2RsppGilghAtzG6meaeKzmXkmbwwswt4FqBuarM2vG7vGjvYNZ32iJcAvtEBw6jHIXlK6e0oMPXfeCjJ/Q2e/z8j8/xR78/AvNPGxK6xxo2Gg+DetucfGn50A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0NNh/HJboUH4m5AVirtwllXSICSALlhrKjrAMej6h4=;
 b=w5d3N7G2Rfknxa3OooRW+SI0rdpWhgCfkWHug1vOeOB7mRlmJ3amTAiHEBAK89JygDynzekXvKZse3nCJMWGMVwqxUE7aFwK482garXn8BymMAACvGYyKomQIW3n8LrmdMMUxF0zV2/87kmELjo2F4jATapnXy+rge/ftBB20yE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB5402.namprd10.prod.outlook.com (2603:10b6:510:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Thu, 16 Feb
 2023 12:04:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 12:04:30 +0000
Message-ID: <b39d505c-8d2b-d90b-f52d-ceabde8225cf@oracle.com>
Date:   Thu, 16 Feb 2023 12:04:24 +0000
Subject: Re: [PATCH v1] iommu/amd: Don't block updates to GATag if guest mode
 is already on
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230208131938.39898-1-joao.m.martins@oracle.com>
 <5df77c33-21cd-51cd-92c6-46241951e30a@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <5df77c33-21cd-51cd-92c6-46241951e30a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB5402:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a8939d-16e2-47b6-0931-08db1015f5ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smtMPFSthSWoYhHZijWtiKz6VSN50UnffTwwtV2zO2a8CumcIwFMm0SsmtVmd9TJG1B9mnthCOKOSJvys0JIheUvmnhFReUjYx3cCZftqIwG3yCf+sWxcjQmFVbPSGq2I05fpX/LB0kgH9AdGPeE6qBCI+/xplwDXny1wQTsqj9pBmD+zykBK8AM8EtyIPIpAC6A1qaNsfityP3caXFL4rNFU7WvvGVFCEWiOpWG6ppTx770vPqjnLI5EeXHEAsp6gWAD2lEJ8GYy4RUXyLSsbVWMQUV3x6Vq5cSTrFpq/1hEwbdSrCQ33m6BUl0JYmBknPpKq05H9S56BmnlxhZkSzipWWWAkga/1pzKnT8JKmeD9vpmSCV9PAnr28uG8TNlOh+G4am5iN86hbWM+6Ow6FAFIqC87hWE17OsvIu0nBWU3Lwy0cWj+8yoxy2g0p8arhyOtpXSzUBoUmCED1S5/wP4OhFaLr0m9qcZevQQ9UXhhZbEGbreOPT/E4Gy9Gk3TYx0ejDcUSGVnqKHGLtZL2TldauYKKr5K+3RHKlzXy1QZof+W3WyjQAV2tmsDZ6PUdZiDo3lfWBkf2o1SXyoNKTgA7ZBnygJWKhsfPd7msQzpK2ndXa7CfqR1L9YzMhKyN2QolrP/YkPr+vlgIxHFvm9d7J2GLxfjkHcdTkVe/1NEU2AFrDI+70aZEEFg4HOYZACVjfpoYeG50+AUUMng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(8936002)(41300700001)(5660300002)(6486002)(478600001)(4326008)(66476007)(66556008)(8676002)(66946007)(54906003)(316002)(2906002)(15650500001)(36756003)(83380400001)(2616005)(38100700002)(6506007)(6512007)(26005)(186003)(6666004)(53546011)(31686004)(31696002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1R1TGY1a2RMZS9hUjRzS08wdVdYUFFSSElxZVBZdEhXa1p2Q1Y2azVydm5H?=
 =?utf-8?B?MGFWVnhzZkRDcmZ5VncrVXRldWI4U1lwbzd3TmkzZmpkNUZ1WTZiNGhjNHJJ?=
 =?utf-8?B?S2lHMnFLVnUvSVRqeUlDNm5Uakp0TDc3TURRT1Nxempyd1pES0pWVHhFV0dI?=
 =?utf-8?B?aGhVeWtVYjdXY1huK2FyWndIeE5UM2JWVTF5cWF3cnpPejA5RDJkR0pqWFRv?=
 =?utf-8?B?ckdXUjJXaTdUWnF5Ly9tdTc5U1FZV0FuOVB2ZitZTC82YnlubHk5MW82dHhF?=
 =?utf-8?B?Qll6Tk9LaDdxclNROVptMUhhanRxY1g5RkhLWGdlWWVyelhjZ1Z3VjZLWmJX?=
 =?utf-8?B?R0FTNWRNdG82ekl2NkZnWlErcW9Cc2tFWWpVZ014SEVJWjlSNGdVMk0vZitU?=
 =?utf-8?B?Smg2K1BzbDRoODhaU28ycmdmb1R1RmVaMFBhRWdXUFFab3dveUJnc0Y3T3dT?=
 =?utf-8?B?d0VKS3RST0tzMmErbEwwZTJacXl1TU9VMjVWRHl5K3hlSVBBR1REUXVkNEFC?=
 =?utf-8?B?UytKckxRREtCMjQ3bWRHbkEyMmt5Z2ZmMUpVSWp1NmFxS3lsWUxLaUlTcndK?=
 =?utf-8?B?bUpwK0o1c0NXYjhLMFc4bjYxVHpGTEpZUDRzc2JxaDhOT0Y5elA4SGVxL292?=
 =?utf-8?B?MjA5eEpRelppN2w4dnVSYURkUk1LUHZwNHBrek5mcHlYV2tXTUw5YktZNEE0?=
 =?utf-8?B?bHNMbXM3UEkvb2lWTWVpT09HWEluMi95MUNaY1VwTTR5a0hYdzErZjRPalI4?=
 =?utf-8?B?ZFZ4UzFhQ1J0U09aVjJ5TXBjaW9oc1ZyNVdYS1pXamkzbnFvdFhKL1FYMlJm?=
 =?utf-8?B?WnBJZ1MvV0dZR1dSYW9tRWhnZXpzOFM0cFJpdUg4S05pcGJqbGJBM3hva3Vq?=
 =?utf-8?B?dkc2cngxL0lqYnBiTDcvSVpDS0JZSDM5Y0NOaFgwcTNJVFdUTmxBV2o4Rk5r?=
 =?utf-8?B?RFhlcXJubnlWTFNIaUdCL1IyWks3QXNoaE9pcHdMS2FQd2FFZEwwWkNHVVFq?=
 =?utf-8?B?YkxIOGNPOEtSZmZRbVFVREVrU2oxUkNqNldmMFRiTzR2L2dHM2pHbVBYdXZn?=
 =?utf-8?B?VFhNNlg4UnF0d0dwZ0hIQTJldmhYZFdUZGd5cG9QWmh2TG9YUzA1R0dHcmJS?=
 =?utf-8?B?NlNKUnJVYnlFK2VaMGhtdi9DSkRGRkg5S2NVbVdWL3RjNjZTdGpxeG5ndmFr?=
 =?utf-8?B?SFRzNjFxRFFSOHprVXN5SkE1cmVJSktuSW5JUzdyaDMzODF6T3JuNXhYWmk4?=
 =?utf-8?B?cjlEaENyUWU2L2E0L2kxay9OSmhucnFHNUQ3TjNKd3FZcjRWeC90M204eXk2?=
 =?utf-8?B?TlhuN1VPY1kwSWQ1R2dOMTJPb2prdkNDbDZqRTVSUjZFZEFPWVZmcmIyMjVJ?=
 =?utf-8?B?TVE5ZEwxTm5BVEYvTFRuUW5mWHR6RkZIaTc0dWRoRlFzc1BONGxQWmFXZnln?=
 =?utf-8?B?WkdHejgrZnhyTGx2M3ZEdWRWN1JJYzQ0ak9XNWVFZ0tIUjNrSkRLNHgwRS9m?=
 =?utf-8?B?dGhWdmVYNmJST3A0NEdWU2Z4UGlUenp5clloNmVYYzc2Qk0rSi92TWRFdWp5?=
 =?utf-8?B?bWUrdzJvK0xpdDZuZXVjYkV3VW4wNjA1MGJPYXIzY2c0dTFzc1FkOUxnWnVE?=
 =?utf-8?B?dlBrS3dndDExTFVOVkxGQUlscjEvQzB5ZTZUV3dkOHEvdkRDV0JkRTZVL0VR?=
 =?utf-8?B?NFRudndpUkdiQ1ZFOURkOVhKNHI5alRLMUQxTDBoOFhHWkpPTjJHWThudlg0?=
 =?utf-8?B?YTNYK3F0cEpaME9NUHBLL29Td3RnRjU5UDZzdmYzTHI2RFpoK1pnRWNKVlVk?=
 =?utf-8?B?TzRaeWxUd1liQUZIV3Fid1VQRlhTcnV1VVJBOVZ6WHl2VHRUSkxwNE5lNXlO?=
 =?utf-8?B?OGpTalM3bkZlRy9kSFcyN1VJQm9xQWd3NjdObmRkRkV1S3BHRHByZ3QyNllx?=
 =?utf-8?B?YnIvNXBoN2dZV3V3UXAvRUlIWnFKMjRlSmwwbStFSk9FNXE5dlg3SEZ3UTRw?=
 =?utf-8?B?WVZUcTQrYlRsSkJ1U2lOeXZHMlJHK2xXSDFGRjRXdHptclBCZ3JOSWdpOGh4?=
 =?utf-8?B?WllSY1RhWnRHU2oxZnczR25EOE5jaXJYNmp1U3hnZkNnRGxRMnRpTitqWElN?=
 =?utf-8?B?Qmp3RCtDZmFlRlppMC9nQm56L1FWU1QrWTJjc3I3ZllXc1dIOEQzNjl6TjBM?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M1JxUGxXSVdnMXM2Q25TMmgzMmVYbnV0dzhITEpma1NHRkRuaUJFamM3c2lm?=
 =?utf-8?B?SjhYRUp2VTZRa1ZLOGlTVTFQRFBaVzhjZDA1TUlUdlBHb2ZzY0U4aU9qVnZl?=
 =?utf-8?B?dW9YYlF3WVZxL1FCR05hd2RUS0I3ZUMxdGpPRjdvNEhiNklNaEROaUtSMFRG?=
 =?utf-8?B?a05STHdFN3pQNm5kMzRhWFc0OWQvVXZkdHZaVW4yMUFRaVBKc01DTis1UXB0?=
 =?utf-8?B?bC95M093QithKzV1Sm8zTXJ6a1ZnNUNOam5pVGtFYU9wQ29vVEhncG1FaS9q?=
 =?utf-8?B?dEtGYTJkZUpyZit2K3RRbGZZcUlMaW1kTllTa2NxcGszdmdXcUhCM0pzT2lB?=
 =?utf-8?B?RDUwaG5YU3UxK1JyYzRvZ2lqK3JQSXFPcmNJby9MQWI0dzZsQXRxT3lBWlc0?=
 =?utf-8?B?SWgrbWVYTENUb1hwdS8wMDQ1b3p4WGZuZm4xY2s0MHlpd0NrQ3N2TnRkS2Vo?=
 =?utf-8?B?aCsreTU5LzFpMy9nZGNhWUR1RHl3V1dKcTZYWGt6SGNZQ3k3VjFDNVdqV2hM?=
 =?utf-8?B?OXRjS2xSWmx4cEdwNmZWUTB0dWpDZ3B5clp6UEJLOElEUnJBaUtQNEVONVVM?=
 =?utf-8?B?TW9wN1lsUEFZRk40Q2F2VGhLVHJXS0MyVk9nUWsrdktiZGhBZ0JwSWgrRll2?=
 =?utf-8?B?L3p3UmJLM1J2OFlhU2lGbm5rdHh1OU1VK1psU3lwbEJuNEhCTkRJQVJqb3pP?=
 =?utf-8?B?WjBxOE05NG9wUzQ4RDhpdHlpdzQ3SkovQTdKTk9ObDZOK1c1bkFjaGJWSkxx?=
 =?utf-8?B?aU1hN2R0K2dIWGpnL0xhUkZQTWFYZ1BGY0kyRHp0aWFoK3ptWEtSb25HUU1W?=
 =?utf-8?B?bW1iSG96SnNNRFZCNnRRWWx2SlhtREJoaERQMS8ydGE4MlAwVHpqRTdTTWht?=
 =?utf-8?B?SlRYbDM4YnpSeTUxSTl6ZW4rSnJQSXJ4a0Zoa0NTRXJVdG5rN3BvQzZEQmx0?=
 =?utf-8?B?ZFM4OVd1SFFlWFVJZzFDUTZwbHFYVTVZTjdzZEZ3REY2L1Frams2bkUxRVEx?=
 =?utf-8?B?OCtCY2dLUm1aZnBIZDh4WDlVeDI2MXNRODcxdDVwZGVUT01NQnpWZ0pnZ0R1?=
 =?utf-8?B?R2dpbUk5RDVzS1ZoZHRnMnRSeXRHU3krdGcwSVVmcy96NWFWL1hWdk8zcEN3?=
 =?utf-8?B?NzNTb0JuTUljVllPRjFnb05MZWs5MnNONWlza0I3UVRkQ0crd3ZETHlrSEo5?=
 =?utf-8?B?T3RpZXJxT2w2M2hNU1l5Q1h1OTZWMzRpVHlxTFpkbndwUWx3cE1zNjltVkZN?=
 =?utf-8?Q?pRxoaGq/nbgk5kR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a8939d-16e2-47b6-0931-08db1015f5ad
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 12:04:30.6422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nQGVt5wcwPTJeuEdI3JCYDAxbMBSWMxcsX5Hn4zGHHgdvNeNQvwpOplTAsTdkWRSgLQnKh1FFjmr333rhWB4VladwWJFROOi+H8Nk3sILU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_09,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160103
X-Proofpoint-GUID: ZLfCW_MjNSjO94M6EzQOUE8hCltyVFSG
X-Proofpoint-ORIG-GUID: ZLfCW_MjNSjO94M6EzQOUE8hCltyVFSG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/02/2023 11:42, Suthikulpanit, Suravee wrote:
> On 2/8/2023 8:19 PM, Joao Martins wrote:
>> On KVM GSI routing table updates, specially those where they have vIOMMUs
>> with interrupt remapping enabled (e.g. to boot >255vcpus guests without
>> relying on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF
>> MSIs with new VCPU affinities.
>>
>> On AMD this translates to calls to amd_ir_set_vcpu_affinity() and
>> eventually to amd_iommu_{de}activate_guest_mode() with a new GATag
>> outlining the VM ID and (new) VCPU ID. On vCPU blocking and unblocking
>> paths it disables AVIC, and rely on GALog to convey the wakeups to any
>> sleeping vCPUs. KVM will store a list of GA-mode IR entries to each
>> running/blocked vCPU. So any vCPU Affinity update to a VF interrupt happen
>> via KVM, and it will change already-configured-guest-mode IRTEs with a new
>> GATag.
> 
> Could we simplify this paragraph to:
> 
> On AMD with AVIC enabled, the new vcpu affinity info is updated via:
>     avic_pi_update_irte()
>         irq_set_vcpu_affinity()
>             amd_ir_set_vcpu_affinity()
>                 amd_iommu_{de}activate_guest_mode()
> 
> where the IRTE[GATag] is updated with the new vcpu affinity. The GATag contains
> VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM (via GALog) when
> interrupt cannot be delivered due to vCPU is in blocking state.
> 

Will change for v2.

>> The issue is that amd_iommu_activate_guest_mode() will essentially only
>> change IRTE fields on transitions from non-guest-mode to guest-mode and
>> otherwise returns *with no changes to IRTE* on already configured
>> guest-mode interrupts. To the guest this means that the VF interrupts
>> remain affined to the first vCPU these were first configured, and guest
>> will be unable to either VF interrupts and receive messages like this from
>> spurious interrupts (e.g. from waking the wrong vCPU in GALog):
>>
>> [  167.759472] __common_interrupt: 3.34 No irq handler for vector
>> [  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
>> 3122): Recovered 1 EQEs on cmd_eq
>> [  230.681799] mlx5_core 0000:00:02.0:
>> wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
>> recovered after timeout
>> [  230.683266] __common_interrupt: 3.34 No irq handler for vector
>>
>> Given that amd_ir_set_vcpu_affinity() uses amd_iommu_activate_guest_mode()
>> underneath it essentially means that VCPU affinity changes of IRTEs are
>> nops if it was called once for the IRTE already (on VMENTER). Fix it by
>> dropping the check for guest-mode at amd_iommu_activate_guest_mode().  Same
>> thing is applicable to amd_iommu_deactivate_guest_mode() although, even if
>> the IRTE doesn't change underlying DestID on the host, the VFIO IRQ handler
>> will still be able to poke at the right guest-vCPU.
>>
>> Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation
>> code")
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>> Some notes in other related flaws as I looked at this:
>>
>> 1) amd_iommu_deactivate_guest_mode() suffers from the same issue as this patch,
>> but it should only matter for the case where you rely on irqbalance-like
>> daemons balancing VFIO IRQs in the hypervisor. Though, it doesn't translate
>> into guest failures, more like performance "misdirection". Happy to fix it, if
>> folks also deem it as a problem.
>>
>> 2) This patch doesn't attempt at changing semantics around what
>> amd_iommu_activate_guest_mode() has been doing for a long time [since v5.4]
>> (i.e. clear the whole IRTE and then changes its fields). As such when
>> updating the IRTEs the interrupts get isRunning and DestId cleared, thus
>> we rely on the GALog to inject IRQs into vCPUs /until/ the vCPUs block
>> and unblock again (which is when they update the IOMMU affinity), or the
>> AVIC gets momentarily disabled. I have patches that improve this part as a
>> follow-up, but I thought that this patch had value on its own onto fixing
>> what has been broken since v5.4 ... and that it could be easily carried
>> to stable trees.
>>
>> ---
>>   drivers/iommu/amd/iommu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index cbeaab55c0db..afe1f35a4dd9 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -3476,7 +3476,7 @@ int amd_iommu_activate_guest_mode(void *data)
>>       u64 valid;
>>         if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
>> -        !entry || entry->lo.fields_vapic.guest_mode)
>> +        !entry)
>>           return 0;
>>         valid = entry->lo.fields_vapic.valid;
> 
> Apart from the commit message change:
> 
> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
Thanks!

With respect to my notes please ignore item 1 as it's not a problem as far as I
repro-ed. With respect to item 2 in the notes, I have the diff below to address
it under testing, which avoids the inneficiency of marking an IRTE as
isRunning=0 (so avoid relying on the GALog after the IRTE update). This is so
far 2 additional patches. Essentially it boils down to fixing
amd_iommu_update_ga() to avoid @entry and @ref going out of sync and then
switching only the GAVector and GATag while not touching the DestID and
isRunning bit (which are more tied to the running CPU).

@@ -4395,14 +4395,17 @@ int amd_iommu_activate_guest_mode(void *data)
            !entry)
                return 0;

-       valid = entry->lo.fields_vapic.valid;
+       if (!entry->lo.fields_vapic.guest_mode) {
+               valid = entry->lo.fields_vapic.valid;

-       entry->lo.val = 0;
-       entry->hi.val = 0;
+               entry->lo.val = 0;
+               entry->hi.val = 0;
+
+               entry->lo.fields_vapic.valid       = valid;
+               entry->lo.fields_vapic.guest_mode  = 1;
+               entry->lo.fields_vapic.ga_log_intr = 1;
+       }

-       entry->lo.fields_vapic.valid       = valid;
-       entry->lo.fields_vapic.guest_mode  = 1;
-       entry->lo.fields_vapic.ga_log_intr = 1;
        entry->hi.fields.ga_root_ptr       = ir_data->ga_root_ptr;
        entry->hi.fields.vector            = ir_data->ga_vector;
        entry->lo.fields_vapic.ga_tag      = ir_data->ga_tag;
@@ -4579,6 +4582,7 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)

 int amd_iommu_update_ga(int cpu, bool is_run, void *data)
 {
+       int ret;
        unsigned long flags;
        struct amd_iommu *iommu;
        struct irq_remap_table *table;
@@ -4601,15 +4605,18 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)

        raw_spin_lock_irqsave(&table->lock, flags);

-       if (ref->lo.fields_vapic.guest_mode) {
+       if (entry->lo.fields_vapic.guest_mode) {
                if (cpu >= 0) {
-                       ref->lo.fields_vapic.destination =
+                       entry->lo.fields_vapic.destination =
                                                APICID_TO_IRTE_DEST_LO(cpu);
-                       ref->hi.fields.destination =
+                       entry->hi.fields.destination =
                                                APICID_TO_IRTE_DEST_HI(cpu);
                }
-               ref->lo.fields_vapic.is_run = is_run;
-               barrier();
+               entry->lo.fields_vapic.is_run = is_run;
+               ret = cmpxchg_double(&ref->lo.val, &ref->hi.val,
+                                    ref->lo.val, ref->hi.val,
+                                    entry->lo.val, entry->hi.val);
+               WARN_ON(!ret);
        }
