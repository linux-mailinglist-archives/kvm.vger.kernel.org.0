Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C491A7AD43B
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjIYJJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 05:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjIYJJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 05:09:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B071A9B
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 02:09:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38P8xSDq019884;
        Mon, 25 Sep 2023 09:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vQo2owD1s4OaHUnb9FVSwgDYlYEUIHCz5mHGBuV31es=;
 b=WegITx94iehA2ggMnwzDvdRonli93Ak9YF89rnPl6dQdrZh5wOLmIN/O+pm7TXTkzxRt
 HQv9Df+cYYW/gViXc+OjEEYCyuIRObs1me/nNIPrT7TqD/FOJcaXzXF023NNk+OWbrhZ
 DeIpfsEohW5htzCN59eNLdMyUOKmAIXDn75MjifNbOrEjbMtEAIBto3Lue8YwaphDQPE
 uTt9aUWW0ImUpp/M/beO0OZZgHkRxagMSMtL19V4yU25F6gpIVeaqIR/I8MHnjxMjN2c
 ik2LkJJSjfkty1eQv7B8iTT13+Q8nWJTeg4J8ZhVDyw2Q6c4dZMoEWeHSVVTPGneGvzD Og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9rjub5jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Sep 2023 09:08:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38P845gO034972;
        Mon, 25 Sep 2023 09:08:52 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf4eqe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Sep 2023 09:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6K4hlRj1UkmoZHHipC/UOmIqYB1jr63kv++yAHj689ddbiwZk/UDhlrFbAbfDmD2PZIV3TSNrp8cCgdIW3N3Be6Qx/Iyd6Ae8ZjH9e08HAPCwfkAYvUZIDrp2zthbylvcyor7gdgoMgT/XMo1xY98f/H0ssVRwwL/EervK2pchS6aKJuID04Xl4lvYccODMQXoHQU6Pa4UY3xKwoAm3LXDEb+ia7KRzRzwywS6dplhSMOzFCJSrsczLx8WxJiXIczhJhvC+cVROE2+F+tH4C2vnfkgjEi49RaYc9HRZ9v3fdu7s2CC9fbGShlfg0W+T8ZRLrpNNzQ+cpSAXAjwG6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQo2owD1s4OaHUnb9FVSwgDYlYEUIHCz5mHGBuV31es=;
 b=I+aELDJueQLZTOjpYfm/bh8OyI9AqkXQAVpxnePlsOkKXXdzsqJMT2eB8aOj3NpwwRzlzyQEW90f+k69wTIKf7RWaQw2Py0QRSr8jhlObszla7CeRE0D8XPKwVqvTEyiNZZknY6lmbEwPUEh9p3YRkQvVlXqceZ3jmM1JBcZBB7A52sDWOW1G9FwwBn/2Xy+u4VhRooV0a5mm9JFWOQqp4tJ5BdieXnBqg20tu4pjCbl4g+HyBQJJsvH1+n/UzDqCTxbon1dmbSe4Eo8Odx2MJsvuE3mRJfvk/CuNNbeOxndO19Ke0KXhOxeM/wI6mZZW8DuRmgHaQ6Oy1OEzW7gXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQo2owD1s4OaHUnb9FVSwgDYlYEUIHCz5mHGBuV31es=;
 b=jLKzoKsqbhnElmXkwKKDU8qgjX+DVpWxwTsDi4C3i/zehv+8Z4qWWVTaX5OddiXVJAKMidqA6PV2nNemJmxYbPPpSvnSETGBw0mXeicYKpJwd7btV6TU8GYPMWVDVbIKXpNur8JAwRefusbZQ8a5nUIfYt0P1FIfsmaI5pwabmY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MW4PR10MB5811.namprd10.prod.outlook.com (2603:10b6:303:18d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Mon, 25 Sep
 2023 09:08:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518%3]) with mapi id 15.20.6813.027; Mon, 25 Sep 2023
 09:08:46 +0000
Message-ID: <d5e35a74-f44e-41aa-8599-059af888b9b9@oracle.com>
Date:   Mon, 25 Sep 2023 10:08:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <32ad48e2-0aa5-2c26-4e75-16e7b1460b37@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <32ad48e2-0aa5-2c26-4e75-16e7b1460b37@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0047.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MW4PR10MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: d6fc806c-99da-486c-a0a3-08dbbda70613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QEAKs0Q2FAO0SnFDEb2R8gmKld5hVPD/6FuyVeYQDDbbN0vEoeMl61plzELxl8qaVM7v+eVJ8NoE3jtO+yyjoYwB8mFAky+fwYa3j/CyNbGPLU3YxdNFuGNJlvPmRE4Jz00fcjf6QAVpsmMnt7YxHx20NAdi1aQLKaz2Jo+fxQRqvZizDJnC4jVgAYlRwQaKG3JtYjJfiUXhYURbcP2xXTLDKjD8JRGm37qB5+5ZVtBWvaX4Rq9vWH0cXEDpjYyoPgvHpPQIlezZJTSR2mBDHbfNKJUKAKbeS/tf8C6Ccj7bdTSksoacj62LvkdCZKzN1BJdf+1M92UzSd3ouyYRm5FKkdELvqrs2J0Rl8b+ZgNk4zzCldYLJ0TuEgKo7NjyFl0g3/UqyMrXN2b5eGOWP2OzFbWG9e+phVQbUR0yhJZABtPwvrurBhcyoJElelJMzUCvvDIXk0o83eLgooRWkve3mCLrt2H7qHMcRCGNCFzbZd/DYNnN5PgTvhYOv1u/2jPNL7NBhe3Glan71iUFxIlLILcY7cd5l6iJ83jcHYNk/AnAY0Z0g/r1RRE2BdHES6F/sg/G5/TRtcAAjx5w8q4J/kDKItcDlx7xlHSF3oNU0adSagDjq7GzcYGOljjXD4AQv2lCwf7glPsIvUUi3t4rJ9nMRventjU86/WAoo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(39860400002)(376002)(346002)(230922051799003)(451199024)(186009)(1800799009)(83380400001)(6666004)(2906002)(7416002)(4326008)(8936002)(8676002)(5660300002)(86362001)(31686004)(31696002)(26005)(38100700002)(316002)(66946007)(6512007)(478600001)(53546011)(6506007)(6486002)(54906003)(66556008)(41300700001)(36756003)(66476007)(2616005)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUdkUTdzWUNvWFRtbG9hNDVxdlFqSnBlakZDM0dwU2VCTXdpWlRpQnUxbzJL?=
 =?utf-8?B?RVNIeVB0cGY2RFpSTHdGVXZDajZkbG8ydDVKRGZoQUd6eGlNV1MrT3VvOEFm?=
 =?utf-8?B?SlYxaWZib1pZbjhCUm5pMUJWNHFROVdPUkxKZG55a0xxTXIxQkdWK0lMOG42?=
 =?utf-8?B?dWJrVGpiNUwyZzVYcnRTMlowL09YWitYcWx0L2gxYmVkU3pxQUFTWVZBaUk5?=
 =?utf-8?B?Y0tNcFU0T2lsNC9ZdFpkVTJRdzZmbTErOGFpUS9JRWNaR0JaS2ROSFM1YkV5?=
 =?utf-8?B?Z3VXZm83NWxQR05CeEk0VVJaR2pGc3JPR0R3VjVJMVpyZ3doMUFxd0hnZFBY?=
 =?utf-8?B?dCtzbVlpOWFFRGlXdXdXMU5rM0szZXIwQXM0amJJdnh1OGNhUk0zbUhQQkt2?=
 =?utf-8?B?eGdKWWV0eVkybHE5TkFVVW5aNUNxSzJXeklyMnBycDlXY3RvRFdrNFdSODNx?=
 =?utf-8?B?aEtXRW5qU1RpVnZqamNhZW9JbUdEbCtZdmhoZlFrRC9rMm9nNUZqcisxejE1?=
 =?utf-8?B?QWZXVzdCM3NHcERLZDk1ajU4b0VNMkpRM3RoMUs3a3RyQVZGYVo4NVMxYlM2?=
 =?utf-8?B?bW9VbVRaUmRxZWdqem5tTDd2Y3lFTkpmYkt1OUVYT1U3bTB6a3B5cm14VGpr?=
 =?utf-8?B?YVBDVFdVSG5mbHNkUTE3bm5pYW5rRHpNT1NuSmU2b1ZVR1Ayd0pnamVLTGh2?=
 =?utf-8?B?cmJKUitGOFh2WmhXa2g0dk9YWkpPQlh0M3ltWmxURERvKy9DV0VqcjVyWHJi?=
 =?utf-8?B?NEdIekVjcmlubVc4RTUvdjBxZXQ5Yi9kcXl3U2pzVFd3blhReG1iSmFNbkhV?=
 =?utf-8?B?bENiS3FTWDlDYm52T3E1eXpsQ0tMcmsyYXdJdkU1MkRwOFl2aFA3OEFhcWJW?=
 =?utf-8?B?VVpHY2NTTlhIZFpnTGQvZFVQVXk1cjRUTnduOWY5eXRYeXM3NFVMRHk5dWhx?=
 =?utf-8?B?L2h5N2RxTnI1N016MHFuQmpvYk9ZaE9JanA1OStNSU9ZNFRXYmd0YklURlpX?=
 =?utf-8?B?VWtUQWFhQjQwSEsxSjd1WEFLMVlHUE1ZZEJiTHFXdHVnRjc3elZ1RjhwUGsw?=
 =?utf-8?B?KzZWQlRmakJIRDhvZjlSUmRPNndlYTFGRkxKZ29QanpxVVh2dFdBV0R1U0lB?=
 =?utf-8?B?ZUVUZW9YZm9Hdjk3SG5hWnhPcnVtQXBtdVJCMnZkRnFpVDkrWVdwZW44cDRm?=
 =?utf-8?B?SGQ2Zmd0KzIyUWQvNURyeHBuTE16d2d0czFuLythRjEwVFEvNGEvZmJQck9z?=
 =?utf-8?B?TDZIUFpMR0poQlA5bS9KcGxKTW1vSW9LaGxuZkgzUHRURzdZWHF3R0tMSWht?=
 =?utf-8?B?Y2pTVzc1SVZSK0phTlJEckdaeXZhQ3RkR0dud3BtNlZlUEFia0o1Skt4a3Vr?=
 =?utf-8?B?bmhoUTRPaWl5ZXRaZ3NOeDE4V0pDQU1FR2hoNm1mdlk2L2NKWUZlZXp0VGtq?=
 =?utf-8?B?Lzc4dmNQWFMwT2drbDdLNGYzQXA2YVROd01SdDdKb3NLSmw3VlpUSTdINndM?=
 =?utf-8?B?LytBQ3p0QWplQjRXSzNJTTFwdjhEenR5NC84Y1dValg4UnhWckNhM1lrZEtq?=
 =?utf-8?B?cklyQXM3OVBsd0pnaWhpcXQzdDZqS1NEQkpVOUZydXA4ZXRNVUJzS1dLYU9Q?=
 =?utf-8?B?bkIxUzlUUm5QdUxHeEdnT0c2SHlobWgvOHhCSmhwcWJGbGdBbSs5ckdmakhh?=
 =?utf-8?B?RXQ2ZHFxWXJHU09oSmZCeDBLNHFDUU11Nitha2lIRXdPeUJQbWd0Qlo1eVg4?=
 =?utf-8?B?eE9yMnpldHhDYnEyTXp6RWhsbGRnWW1xSFhMUjNWM3lWOFFnYXoxMUxhK3Rl?=
 =?utf-8?B?R1YxYTlWdlczNW4vb0hKM3VHZ3N2QzBDWXF6ekU0bDhxQjhNOFNiM1dRUWJN?=
 =?utf-8?B?VkVjN09CZzhCL3J5aEt1UXM5RlZCSXViY3Y5VVJJV2pOTStYT0VGWDNHZ0g1?=
 =?utf-8?B?WmxvU0h5SE5oays5aUthOGdwK0RtVk9Vb3NYVzlzZDNQSUxVRGo5ZnJGL3Np?=
 =?utf-8?B?alZEbVpmQWFHdUZVUEh4YnNTZ2ZDbGJ2M3BQUzdRSkoyQURjZDJIMnBaSWhp?=
 =?utf-8?B?RVV0L0JVWlNoK0pTY1lmeHk4YVpUVWJidWtaVFBhSDZqRC9TNlpxV3o3L1BY?=
 =?utf-8?B?emEzbVNHUnBpeU5FbG5vVDNqYkh6R3drN1pUU0E0Vnc5S0FReVBKMWZwN2xk?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cVV1ZGhiZ2hFQXNSV1hXNTlpN28vS3h0Z3RsU2JwcEdmelZyZitlMWJMRi8x?=
 =?utf-8?B?S1VHYkFKNEhEUzRaeUMzV25uRFJBQXZwS09VZ3MzTzkyNk5JQTg5Z0pxK2lw?=
 =?utf-8?B?NENKZUxRd0FDb1g5eWh1aTN4dkxseU9DS01leUZDKy9ZejgrUTlKakdEUXBR?=
 =?utf-8?B?REJINi93S3lKQ3NZNHhmVWV6b1ZxbzlDYmFBaUZhaUtHUTROanRRVWRha2lz?=
 =?utf-8?B?elVua2VRaWxxSk56NzBzNWNZMEJCblhIdnQ1akZraFdrbmdDd1Arell1MDN6?=
 =?utf-8?B?aWg5bnhXSFdseGdybGpaSjlHQTFReE5GRjlvZnJIUzUvelV4SjB3ZndUMnBs?=
 =?utf-8?B?WGltQWhDZ0VES2pjWmdBMTdlb1VEUzFaQWdFUnM5TndBSlVjZG1sMThOMHNS?=
 =?utf-8?B?YzVhRmZGa1BhQXVMUXFmL3FSY01HWitra2kwWnp1OW00MzJzN2pCMXU3TXVP?=
 =?utf-8?B?RWZMVVBrTlo1d09mS3dYK0VUUjhseHVBK0RZanFZSlp2OFV1M3pTRTNMc2NB?=
 =?utf-8?B?QWFpaTg0S3JPbG4vZGJLSHVvNERqaHhGenJHS3VTZHdyZWI4ekE2U3BLL0J4?=
 =?utf-8?B?WHFUaWU5bFcya3lXeEFCNEZmbVZTckg2REd5b3VwdmZwUmluUGNoMlZ5clJI?=
 =?utf-8?B?OVlGWmI0WWdjOVNiZnJvNVNXVjUwYytnLzRuY1pOZ0VkUTdnd3l2RFZDOVZZ?=
 =?utf-8?B?MjRhNmUxblQ3aHZVOUgxWC9QRlQ0RkF0SWduR2NmVjFOU1l3MG9MOW9QMEgx?=
 =?utf-8?B?Q0ZRTGVEdXFtQ0xiZnI1VWxLZk1Eelp5RzNWV3pRMitySEpUSFI0ZENYME1w?=
 =?utf-8?B?bW8wY3BDUmRTdW9SWkY2OTFqKzdVMWo2ZUoyNVluOWd2SjNaOWZINFB2aDdp?=
 =?utf-8?B?WG1VdGVFWkVzVlJ5d1I4amF3YTkrVTBwRGZ2RFVvSFcrS3BmZmIyNnY4di9j?=
 =?utf-8?B?cTJydkJXOExScjFCalJMK2NYS1Y5K2NGaUZTWThVdFlpeWJSM2E2SnNjYjlU?=
 =?utf-8?B?Qi9McVVPSEZrSkFsK0IxYlEwTXhUd3VFR1lqeVVTT1d4enlGcm5zR3B4RVZK?=
 =?utf-8?B?MFlLR1cvc2ZtZGc1ejU2dnVMQmhTQ2RKZ0t5M1h4RTFmbXZBS2ZvZU1XSXlF?=
 =?utf-8?B?QUt0Q29KYUQ0SndSWEdkSTNpMWdNWWhtd1JEYzY3aWpjdDN6OFhRSElRZDFz?=
 =?utf-8?B?bUtWZ2JxK1E1Y3RzallJNlY3M3BVUlFVeCt3ekV6R3ZoUU9zQ0pIazE1bm9r?=
 =?utf-8?B?K2tDV21wU0JMNjdYZDdTLy9lQUlSR3Bkb1Byc1pYdEZoSWZQVVdQemdpVGNK?=
 =?utf-8?B?Z3FzNG1GNlp1QUFtRGVZcHAyUjk1VGM4RittM2thRDNlUEt6NEhod2dmaHVx?=
 =?utf-8?B?U2hxV2tnRGRMM2dHQ3ZEZ0l0S3NDdTJ3S1IzMmdKSkhWOHpPS3hFRFlHNlRu?=
 =?utf-8?Q?rgZ8o7B2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fc806c-99da-486c-a0a3-08dbbda70613
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 09:08:46.4006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuL4ed0Vd/p1tzeupG34aAIK5H4BN61TCZK0zQX1N4juinpU7EB56xue1U83ShbzUDS2DI8e5uPEVp/fho1sQ1Hk2/y8aaYVJ6OaYuGCDhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-25_04,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309250066
X-Proofpoint-ORIG-GUID: QMVYfU-lu5mF5NBgxCSab9lC6zS0ila5
X-Proofpoint-GUID: QMVYfU-lu5mF5NBgxCSab9lC6zS0ila5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25/09/2023 08:01, Baolu Lu wrote:
> On 9/23/23 9:25 AM, Joao Martins wrote:
>> IOMMU advertises Access/Dirty bits for second-stage page table if the
>> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
>> The first stage table is compatible with CPU page table thus A/D bits are
>> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
>> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
>> "3.7.2 Accessed and Dirty Flags".
>>
>> First stage page table is enabled by default so it's allowed to set dirty
>> tracking and no control bits needed, it just returns 0. To use SSADS, set
>> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
>> via pasid_flush_caches() following the manual. Relevant SDM refs:
>>
>> "3.7.2 Accessed and Dirty Flags"
>> "6.5.3.3 Guidance to Software for Invalidations,
>>   Table 23. Guidance to Software for Invalidations"
>>
>> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
>> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
>> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus
>> the caller of the iommu op will flush the IOTLB. Relevant manuals over
>> the hardware translation is chapter 6 with some special mention to:
>>
>> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
>> "6.2.4 IOTLB"
>>
>> Signed-off-by: Joao Martins<joao.m.martins@oracle.com>
>> ---
>> The IOPTE walker is still a bit inneficient. Making sure the UAPI/IOMMUFD is
>> solid and agreed upon.
>> ---
>>   drivers/iommu/intel/iommu.c | 94 +++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/iommu.h | 15 ++++++
>>   drivers/iommu/intel/pasid.c | 94 +++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/pasid.h |  4 ++
>>   4 files changed, 207 insertions(+)
> 
> The code is probably incomplete. When attaching a domain to a device,
> check the domain's dirty tracking capability against the device's
> capabilities. If the domain's dirty tracking capability is set but the
> device does not support it, the attach callback should return -EINVAL.
> 
Yeap, I did that for AMD, but it seems in the mix of changes I may have deleted
and then forgot to include it here.

Here's what I added (together with consolidated cap checking):

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7d5a8f5283a7..fabfe363f1f9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4075,6 +4075,11 @@ static struct iommu_domain
*intel_iommu_domain_alloc(unsigned type)
        return NULL;
 }

+static bool intel_iommu_slads_supported(struct intel_iommu *iommu)
+{
+       return sm_supported(iommu) && ecap_slads(iommu->ecap);
+}
+
 static struct iommu_domain *
 intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 {
@@ -4090,7 +4095,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
                return ERR_PTR(-EOPNOTSUPP);

        if (enforce_dirty &&
-           !device_iommu_capable(dev, IOMMU_CAP_DIRTY))
+           !intel_iommu_slads_supported(iommu))
                return ERR_PTR(-EOPNOTSUPP);

        domain = iommu_domain_alloc(dev->bus);
@@ -4121,6 +4126,9 @@ static int prepare_domain_attach_device(struct
iommu_domain *domain,
        if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
                return -EINVAL;

+       if (domain->dirty_ops && !intel_iommu_slads_supported(iommu))
+               return -EINVAL;
+
        /* check if this iommu agaw is sufficient for max mapped address */
        addr_width = agaw_to_width(iommu->agaw);
        if (addr_width > cap_mgaw(iommu->cap))
@@ -4376,8 +4384,7 @@ static bool intel_iommu_capable(struct device *dev, enum
iommu_cap cap)
        case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
                return ecap_sc_support(info->iommu->ecap);
        case IOMMU_CAP_DIRTY:
-               return sm_supported(info->iommu) &&
-                       ecap_slads(info->iommu->ecap);
+               return intel_iommu_slads_supported(info->iommu);
        default:
                return false;
        }
