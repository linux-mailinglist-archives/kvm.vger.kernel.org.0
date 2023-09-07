Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06DD797898
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243153AbjIGQty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243551AbjIGQtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:49:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D1F1FC6;
        Thu,  7 Sep 2023 09:49:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 387GOruj008701;
        Thu, 7 Sep 2023 16:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pb5UtGX7g1fWVF4e4ITRE8wRm0Abifk6hgGQUQb0czg=;
 b=gKeTvD9HeDBSialtKgpZoB3mZpm0t3EqlDG9dgPnU2h+MNoRDmhjqm4VJ+C3cuwGU+wG
 EhgR4C/UIIUl11bdG0L9RsF4pRdcERFwEALrzqQTVwsZvtmRJSzZtNHXbbkiLvtqJlrl
 v0acbxJuiue/Ds4m6e9z7lkj/grIeJCJwuiCs5xqUksIplmoHSdC+CQ0S/EKQC03SWdE
 ZOH61lwOsCn6QdWl0/1ZvL19rIfiUvxFjKjiMp/k8rni6XZ3jfSZjJR1vy5xVG1x0fv/
 ao0PAD+0gI9m2zhkyGLyuLu2teu1GPMkn8+W7RnJB+DdaR6jrlvwCk6LjGaUilDdG3eF Cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3syj0qg0t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Sep 2023 16:33:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 387Fejg1031195;
        Thu, 7 Sep 2023 16:33:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug8e7q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Sep 2023 16:33:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hu9j8LBdCmaS3qGlIViXgU93aYldDZWFEby82xzk41z1Ws456yBZ+qwsgWFZitiv748Z1qUl5/LGeCi+YRVRf1XOOmEYsJRuuWna5nyceSvfLlXT69IBBGFgKtQqLm/lexP05VJY68LQQuH6qV+0L2y9x40+UAeOkA3cfyDbMqs+9CMjysv4r6Mmw+bRvBNUFWlNt4OJPtDeknQjLluERGCC5uboNJrxF4NfjLsIQKvMtQwwI0HzE5PvYiJQYEi0YGJa7dPgP1lDDn7Q8nWQjQpIQS5VOzwtP4rxCVo1iq34T2eLEGOBTSS42zo6CqF30AvbwbRSklqrYOu1yFyQCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pb5UtGX7g1fWVF4e4ITRE8wRm0Abifk6hgGQUQb0czg=;
 b=nWYC0aEM2fXCeMwbiXC6vhThh3ZRhQLqGjHyDkl0LenSiHnB+S1wWiEivqFzbJ6GQWsJweoXb3JDVM6F36O8qK8IgE3xfUfayGNM6CcPxuPiGfnz6RYL4X/Uwc9Q9XR71gIWm7OLz49pRXDMU5eGvMzSW0nKPtfdFRHLD7HFGgHYdEf+vW5yLc9zZgw70RMPKkk2qLz7gZTNh12esOa7IlhB9DMWL+rmVP2fHvQw2tifufvS8ZAjSzjALVLq18m7BAHx59gg10l9fTwnZsUaGwr7IOPabMBvRYZoSZ6PSwCdwkdJmammBp5DaqsnJRoeArNywVjpqgOhkb9qsaTIeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pb5UtGX7g1fWVF4e4ITRE8wRm0Abifk6hgGQUQb0czg=;
 b=kwRS3YW7KqfEoXvGxEYrvAAfG+HC01hQJB/2fCIUZ0+gYm1WSsgC0sf5QVcnwUBRUDmxmspfDoqaajlISEgr//Gr6LXSOTwWWNAf77XaK4RYSfId817PfN2edTAPjBwLBP8/GPya+RHguKa1m/TtdWvElJd4Ta8aZ9Reg+vdqcU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB4672.namprd10.prod.outlook.com (2603:10b6:a03:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 16:33:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67%7]) with mapi id 15.20.6768.029; Thu, 7 Sep 2023
 16:33:26 +0000
Message-ID: <6959f434-65bf-8363-a353-2637a561d35c@oracle.com>
Date:   Thu, 7 Sep 2023 17:33:14 +0100
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org> <ZPhnvqmvdeBMzafd@nvidia.com>
 <97d88872-e3c8-74f8-d93c-4368393ad0a5@kaod.org>
 <a8eceae4-84a5-06c4-29c3-5769d6f122ce@oracle.com>
 <c62b99f8-39d2-0479-34a8-c87ed8fc9b22@kaod.org>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <c62b99f8-39d2-0479-34a8-c87ed8fc9b22@kaod.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0146.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB4672:EE_
X-MS-Office365-Filtering-Correlation-Id: 37b46a05-e5f4-48d4-295a-08dbafc02968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBMiRhXMe3yhQDrsojJGl7xnwc6MBo8a7fXIXTR6x0DhDkii7Bo2Ww/MbgsYeuNXNx/R5COmpoG2k1Zw2H0sdEgcYgJDHjM/XoFtYWavgZTSAhn0bUBI6CX6itQnF3nLM6nVNVK3Kv5t7PatLOzPSN9pDgBUTF1fur0k7lqgm548KsCgvhvEx+HKI9FGzXLm+5/OeQ8QouuBvA0RQpGVv/xht9B21c+KhNB3TQdPq0aIUP9fA5k6/6l0uqpAtwVlAaAUAyEoHT3fbu/sTgNDgJYFJTSct6bQAYKkU3c+iPWRSySnQo8Wb5CyrWJ6xMrh1I3FC3HNheARdFCkwIBJy/i6+qJYKrnGDsY56IT8cznsI1TRmqArf9QeqTv4wip/2zH317jHCusxxr3CKPhKnQx7YNSqmHwyTunFO4e+Hg68Gt8vH3NADxH9oezmnuexN2WUpT12nDoCRAYNfhnX03f3iX1cgVq7E9ErscUaTfjE39mHjt5qnjBq/5vHRGQ3WRZS5DVtJduuUPNuHV+qGk1tdWmlXCm2EPOcePUG3FCWy9EfvOWkjWnxBGOWl/bl1Bhki+kE5lLLPXunbF9TEWGfRvL0aLzrvK1b8H7TWtTnIQRESMTk5iPMM9ZcuUaigDm9zUvjNFiWj6xw1ujILg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(136003)(396003)(346002)(186009)(1800799009)(451199024)(6486002)(6506007)(6666004)(53546011)(6512007)(478600001)(83380400001)(2906002)(66574015)(2616005)(26005)(30864003)(7416002)(41300700001)(54906003)(66946007)(316002)(6916009)(66476007)(66556008)(5660300002)(8676002)(8936002)(4326008)(36756003)(31696002)(86362001)(38100700002)(31686004)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGxqdWVyY2Z3a1l6ZnV3WkdYZmp4MGdpV3E3M3Q3K3BvZGZmWmVsS3gza0lB?=
 =?utf-8?B?dGlDOUdDbVhka3VJa1F3SkE3dWhOT3RRZDJjbFdXaFkrS1FSczcwZG1vWFZB?=
 =?utf-8?B?ekpXUFBFdkkvOENDRkJwVDltRDE5N0Ftd3o0RUQ3NGZyd1R5L2dPVXYxcm14?=
 =?utf-8?B?SkdINWR4RHpLOHhBczlCNTNiUDhBSzhCOTdMbGN2di93OTNpVjZiTzNBNnND?=
 =?utf-8?B?TW43bW9ZdWFtTC9jZ3gyRlNadU9Gd0xhcVpJbmlNZDlMaVRjK3VPd3lSVXdC?=
 =?utf-8?B?Ymg0Yi81ZEp0ZTBhUVFZTkIxeE9RYko5T3h2cktsVXZ2UjZXcEk1OGw2ZEpX?=
 =?utf-8?B?bXkxNWpsdzFHL1VLUCtDcXVZdDB2YWh5NDFHd21Xa01jMzR4VGZzQ1R2U2Zi?=
 =?utf-8?B?SlBLVk5PazZONm1tSk9UVGk3SmtGWWJrSFhNMVlEaUlrWXJPblB5R3Yrb1JI?=
 =?utf-8?B?TFlhNHhzajd3OEg2VTRoR3IwVHRwOElvek54dm5yQ09QYkgzVHNCL1VQTGxK?=
 =?utf-8?B?TDNCUUhmRjVRRitGR2NscWZ0S2NJWHZGTGkrWStHTmNwQkxRdm9yZW5vNjJs?=
 =?utf-8?B?cWw3eVg4eXM5bzFKWVZ5Qi9leVBTZ0xoSUxJR2JuaDBvZVlLTEpxTHdZc1Ro?=
 =?utf-8?B?VkhQT2dHaXNaWmFmTEgyS3hKM2w5bVlHNjZrSndzQ2R5Q1E0bHBUMzRCeCtX?=
 =?utf-8?B?K09hc0FvaVpUTVV5ZDIvTDJvazRXSjJBeVZXUm5seHJKTUhYdFk0N0Rhd3ZZ?=
 =?utf-8?B?M2ZyTXZvOXhvZzdxbXlwSHAyTmtyT0dnS21LTzFCNWhHT2FOZnYvR3JRd2N5?=
 =?utf-8?B?Z0dSRncwWTZuaEc1NDcvbkJiV1h1RVZCYUxMZXp1TXg0YVJvdUpzN0Z6aDdX?=
 =?utf-8?B?K1lBYndidCtHVmhMT21zZmdkR0tQMG5iZXkvak5mckYwVjc3R3RibjU4YXRS?=
 =?utf-8?B?OXpPZ2VINVY5U0NMa2hJTitPNEhNbEVrRkg2TVExNzNpV2huNktmL1JZV3I0?=
 =?utf-8?B?Y0tORk5VS0JQTzE4dktIWmVia1o2Ujd6VCtsQTFDeVRxZWZUbW1YL3lsS2NT?=
 =?utf-8?B?UE8rODc0YmhJUjFzeGxNRTJYRzhoaXVSSU1BM1NRY0t3N1A1T1lQTXFVdWVF?=
 =?utf-8?B?ZUt6UDhnQ1A2Zit4UG13VnZyTVNrSVgzclF5VjNIOG94TldvYi8xSXl4YnJu?=
 =?utf-8?B?V1RpUVVnamo5ZU54TmcvdEFLVXBCOWxEQjhSSzdmek81d3ppWjJjR0NFMTlX?=
 =?utf-8?B?OVk1b1VMYUFOaEdxSmxwLzZKaysxMHlTVWw0dVZBNUc1T2JQM2lMRmk3MnV1?=
 =?utf-8?B?TzlGTktmbVdJOFZDSlUwRE92ZENYQXU4TFB6bTlZbHVOOEFkK2E2d0EzWTZj?=
 =?utf-8?B?K28xU2JKY1A4aVhBdzZ1VzhPQTdkMjBZUW9OVDhadGlGSlZlQVh1Q0hCMFZT?=
 =?utf-8?B?ejA0dE1DanMzZmp0T2FuSWw1ZnMzekVTWlhteFpFWGpnalM0dm4wVzNlZ1ZQ?=
 =?utf-8?B?ekYwR0RleFZxYSthYy9FcGxlZTM3KzJWRVB3LzY3cU1RZlpMYS9BeG9SdFFu?=
 =?utf-8?B?dE04bks0bHdGSms2aWhodmNTSE9aT3dZZVpHOVdZVE93dkQ5RzRuM1NqUnlo?=
 =?utf-8?B?Sk9qeUNvam1vSTRTcm41enhlZjROR3daSTV1N2RhTVFlbjFUVU9aQW5EKzBJ?=
 =?utf-8?B?anFjeVpua0hGL2I3K3UzVUR5RE5sSFZabzlkRlZQS0IrWEV2UjAwanF0MzNu?=
 =?utf-8?B?VllPUkxYR1Z0Mzg4SWpiZHlwUTFlck13T2pUUVAzVEVac3ludUpCTDU2S0xO?=
 =?utf-8?B?eFpnYjBuc2dGRkxBaVpuMVRaalhoVlgrZzdrS2xIRkZ4aGhqU0lWbFVoVjJq?=
 =?utf-8?B?ZGRXMWNlS0lmbGpqQTNRcXRzMXd6V3RCR3NpYWkzeW5LQ1R5ZFpGL2REL05w?=
 =?utf-8?B?Q21vdU1RMFRmaW1kT3FHcTRlbndHZjJpZ2pncGxiQ0xoc1k3eDR4MDNRU3hZ?=
 =?utf-8?B?bkx4OGYxSjgvSTRMelQ1YnU3ZDE0SVB6dFArUXZtMG1Va3hYRm96NUJENkNF?=
 =?utf-8?B?c254QVNJY1VTOWo0QlZQdVlTTTlFOTN6NURKUkRHeG9yTytqWW9RcUI4ZDNr?=
 =?utf-8?B?MlBEWDhqZTZRMmcySDUzalhVYnMxUk5naFFNaCszMXBOektxWmFZZUFIbkN2?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /1fWRyBYn6lLHe0LMV72tHn3dRwJ6fFvJkAvJmmFow4Xd5PeS0pE2Pq7PbFBK8owMzEDimASHkIIEKjj7/Q962R9VZjTpjVtSH7Ye7wte5ZNhRfC2juBwG9Sv4UY9VSpuLw4w4j3FHbYRqT/nj/Fqyx9AHsHk2w4Z6NfnVy0x1iP4GE8yOXcLMlOac8UloLS2hYxf7xDq/eP9S+tGPrfwlA245bBipFRylJy78DrmNZubHU74d3F1dGW6SA7b+wUTUsxHjOiqwKCbj6Wmi5kjP4QKHOgp5AG/oZku6lXlCGKFP/nIfphHkvHL+Ay8lVB4SJBCl7qhhQH9mPjmrD95jejPtK3BV5v1SbZJ2QS3mAyuig0y5rIy6FxCKgKWKe5leNUUtbVSAvsKe+XZaapkEBHPa9QWfnudUtkAO0UK/A5r4oWZnHzrclKccW+broJzfYjcCBpZJjnlJdE9Tv1rFslnRdpkMAjgMdVc+445rr2qmgLW5rSMAESf10wRisBJFxsIG+JTKi27DXwS0afkIN44G0tagtpiYtPLyGe2qHZNjnSHUk13dFvvDHIJG7HgKEVas39xu/oP6YH1TCnUAPlTmF8EahWKgpZ1Br5zCmxXq8OJ39M6pzPpEMCc/pWDVIc9e2vS+XiroaVgV/MgZhtuKDdRDWj2aKEaP/h2dInNW1h3OlGL0jLEfe5TdukXBz8n9egbqjSBPPuYnR9qr2DNPf3zgWN9RFcyrs+hSjekkCreQwO8I+QJv1rpslwjTwMUwm8Mxj672uv+Jy6e8yhlWnOl634Ry+gB+4mUK7tlwq1EvNCsSI9DjPfGf9ffIR0FXn25yYcb6zy/nbnNeKY1aQ/VHVJ+LLLiXq7hpBfdIMe8uXoxyCZREfQfMVsGZGnBlBGx4Hr1sIOqQgGUw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b46a05-e5f4-48d4-295a-08dbafc02968
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 16:33:26.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1pNOoqt0TA27YrjzmPOX0S5FQqK2DN13V4GWxrIA0ma91mGpV0ISvvX9sFWCPuDdfTtKkfg5vMY3SbPMDEqpOzU0RBbwoMZ4ooniP4BcDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-07_08,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309070147
X-Proofpoint-ORIG-GUID: uL5fySlsJFPOXHjvbum1VBwG1ws_E8FI
X-Proofpoint-GUID: uL5fySlsJFPOXHjvbum1VBwG1ws_E8FI
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2023 13:16, Cédric Le Goater wrote:
> On 9/7/23 12:51, Joao Martins wrote:
>> On 07/09/2023 10:56, Cédric Le Goater wrote:
>>> On 9/6/23 13:51, Jason Gunthorpe wrote:
>>>> On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:
>>>>
>>>>>> +    WARN_ON(node);
>>>>>> +    log_addr_space_size = ilog2(total_ranges_len);
>>>>>> +    if (log_addr_space_size <
>>>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>>>>>> +        log_addr_space_size >
>>>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
>>>>>> +        err = -EOPNOTSUPP;
>>>>>> +        goto out;
>>>>>> +    }
>>>>>
>>>>>
>>>>> We are seeing an issue with dirty page tracking when doing migration
>>>>> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
>>>>> device complains when dirty page tracking is initialized from QEMU :
>>>>>
>>>>>     qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation
>>>>> not supported)
>>>>>
>>>>> The 64-bit computed range is  :
>>>>>
>>>>>     vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff],
>>>>> 64:[0x100000000 - 0x3838000fffff]
>>>>>
>>>>> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
>>>>> bits address space limitation for dirty tracking (min is 12). Is it a
>>>>> FW tunable or a strict limitation ?
>>>>
>>>> It would be good to explain where this is coming from, all devices
>>>> need to make some decision on what address space ranges to track and I
>>>> would say 2^42 is already pretty generous limit..
>>>
>>>
>>> QEMU computes the DMA logging ranges for two predefined ranges: 32-bit
>>> and 64-bit. In the OVMF case, QEMU includes in the 64-bit range, RAM
>>> (at the lower part) and device RAM regions (at the top of the address
>>> space). The size of that range can be bigger than the 2^42 limit of
>>> the MLX5 HW for dirty tracking. QEMU is not making much effort to be
>>> smart. There is room for improvement.
>>>
>>
>> Interesting, we haven't reproduced this in our testing with OVMF multi-TB
>> configs with these VFs. Could you share the OVMF base version you were using? 
> 
> edk2-ovmf-20230524-3.el9.noarch
> 
> host is a :
>         Architecture:            x86_64
>       CPU op-mode(s):        32-bit, 64-bit
>       Address sizes:         46 bits physical, 57 bits virtual
>       Byte Order:            Little Endian
>     CPU(s):                  48
>       On-line CPU(s) list:   0-47
>     Vendor ID:               GenuineIntel
>       Model name:            Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
> 
> 
>> or
>> maybe we didn't triggered it considering the total device RAM regions would be
>> small enough to fit the 32G PCI hole64 that is advertised that avoids a
>> hypothetical relocation.
> 
> You need RAM above 4G in the guest :
>         100000000-27fffffff : System RAM
>       237800000-2387fffff : Kernel code
>       238800000-23932cfff : Kernel rodata
>       239400000-239977cff : Kernel data
>       23a202000-23b3fffff : Kernel bss
>     380000000000-3807ffffffff : PCI Bus 0000:00
>       380000000000-3800000fffff : 0000:00:03.0
>         380000000000-3800000fffff : mlx5_core

Similar machine to yours, but in my 32G guests with older OVMF it's putting the
PCI area after max-ram:

vfio_device_dirty_tracking_update section 0x0 - 0x9ffff -> update [0x0 - 0x9ffff]
vfio_device_dirty_tracking_update section 0xc0000 - 0xcafff -> update [0x0 -
0xcafff]
vfio_device_dirty_tracking_update section 0xcb000 - 0xcdfff -> update [0x0 -
0xcdfff]
vfio_device_dirty_tracking_update section 0xce000 - 0xe7fff -> update [0x0 -
0xe7fff]
vfio_device_dirty_tracking_update section 0xe8000 - 0xeffff -> update [0x0 -
0xeffff]
vfio_device_dirty_tracking_update section 0xf0000 - 0xfffff -> update [0x0 -
0xfffff]
vfio_device_dirty_tracking_update section 0x100000 - 0x7fffffff -> update [0x0 -
0x7fffffff]
vfio_device_dirty_tracking_update section 0xfd000000 - 0xfdffffff -> update [0x0
- 0xfdffffff]
vfio_device_dirty_tracking_update section 0xfffc0000 - 0xffffffff -> update [0x0
- 0xffffffff]
vfio_device_dirty_tracking_update section 0x100000000 - 0x87fffffff -> update
[0x100000000 - 0x87fffffff]
vfio_device_dirty_tracking_update section 0x880000000 - 0x880001fff -> update
[0x100000000 - 0x880001fff]
vfio_device_dirty_tracking_update section 0x880003000 - 0x8ffffffff -> update
[0x100000000 - 0x8ffffffff]


> 
> Activating the QEMU trace events shows quickly the issue :
> 
>     vfio_device_dirty_tracking_update section 0x0 - 0x9ffff -> update [0x0 -
> 0x9ffff]
>     vfio_device_dirty_tracking_update section 0xa0000 - 0xaffff -> update [0x0 -
> 0xaffff]
>     vfio_device_dirty_tracking_update section 0xc0000 - 0xc3fff -> update [0x0 -
> 0xc3fff]
>     vfio_device_dirty_tracking_update section 0xc4000 - 0xdffff -> update [0x0 -
> 0xdffff]
>     vfio_device_dirty_tracking_update section 0xe0000 - 0xfffff -> update [0x0 -
> 0xfffff]
>     vfio_device_dirty_tracking_update section 0x100000 - 0x7fffffff -> update
> [0x0 - 0x7fffffff]
>     vfio_device_dirty_tracking_update section 0x80000000 - 0x807fffff -> update
> [0x0 - 0x807fffff]
>     vfio_device_dirty_tracking_update section 0x100000000 - 0x27fffffff ->
> update [0x100000000 - 0x27fffffff]
>     vfio_device_dirty_tracking_update section 0x383800000000 - 0x383800001fff ->
> update [0x100000000 - 0x383800001fff]
>     vfio_device_dirty_tracking_update section 0x383800003000 - 0x3838000fffff ->
> update [0x100000000 - 0x3838000fffff]
> 
> So that's nice. And with less RAM in the VM, 2G, migration should work though.
> 
>> We could use do more than 2 ranges (or going back to sharing all ranges), or add
>> a set of ranges that represents the device RAM without computing a min/max there
>> (not sure we can figure that out from within the memory listener does all this
>> logic); 
> 
> The listener is container based. May we could add one range per device
> if we can identify a different owner per memory section.
> 

For brainstorm purposes ... Maybe something like this below. Should make your
case work. As mentioned earlier in my case it's placed always at maxram+1, so
makes no difference in having the "pci" range

------>8-------
From: Joao Martins <joao.m.martins@oracle.com>
Date: Thu, 7 Sep 2023 09:23:38 -0700
Subject: [PATCH] vfio/common: Separate vfio-pci ranges

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/vfio/common.c     | 48 ++++++++++++++++++++++++++++++++++++++++----
 hw/vfio/trace-events |  2 +-
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index f8b20aacc07c..f0b36a98c89a 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -27,6 +27,7 @@

 #include "hw/vfio/vfio-common.h"
 #include "hw/vfio/vfio.h"
+#include "hw/vfio/pci.h"
 #include "exec/address-spaces.h"
 #include "exec/memory.h"
 #include "exec/ram_addr.h"
@@ -1424,6 +1425,8 @@ typedef struct VFIODirtyRanges {
     hwaddr max32;
     hwaddr min64;
     hwaddr max64;
+    hwaddr minpci;
+    hwaddr maxpci;
 } VFIODirtyRanges;

 typedef struct VFIODirtyRangesListener {
@@ -1432,6 +1435,31 @@ typedef struct VFIODirtyRangesListener {
     MemoryListener listener;
 } VFIODirtyRangesListener;

+static bool vfio_section_is_vfio_pci(MemoryRegionSection *section,
+                                     VFIOContainer *container)
+{
+    VFIOPCIDevice *pcidev;
+    VFIODevice *vbasedev;
+    VFIOGroup *group;
+    Object *owner;
+
+    owner = memory_region_owner(section->mr);
+
+    QLIST_FOREACH(group, &container->group_list, container_next) {
+        QLIST_FOREACH(vbasedev, &group->device_list, next) {
+            if (vbasedev->type != VFIO_DEVICE_TYPE_PCI) {
+                continue;
+            }
+            pcidev = container_of(vbasedev, VFIOPCIDevice, vbasedev);
+            if (OBJECT(pcidev) == owner) {
+                return true;
+            }
+        }
+    }
+
+    return false;
+}
+
 static void vfio_dirty_tracking_update(MemoryListener *listener,
                                        MemoryRegionSection *section)
 {
@@ -1458,8 +1486,13 @@ static void vfio_dirty_tracking_update(MemoryListener
*listener,
      * would be an IOVATree but that has a much bigger runtime overhead and
      * unnecessary complexity.
      */
-    min = (end <= UINT32_MAX) ? &range->min32 : &range->min64;
-    max = (end <= UINT32_MAX) ? &range->max32 : &range->max64;
+    if (!vfio_section_is_vfio_pci(section, dirty->container)) {
+        min = (end <= UINT32_MAX) ? &range->min32 : &range->min64;
+        max = (end <= UINT32_MAX) ? &range->max32 : &range->max64;
+    } else {
+        min = &range->minpci;
+        max = &range->maxpci;
+    }

     if (*min > iova) {
         *min = iova;
@@ -1485,6 +1518,7 @@ static void vfio_dirty_tracking_init(VFIOContainer *container,
     memset(&dirty, 0, sizeof(dirty));
     dirty.ranges.min32 = UINT32_MAX;
     dirty.ranges.min64 = UINT64_MAX;
+    dirty.ranges.minpci = UINT64_MAX;
     dirty.listener = vfio_dirty_tracking_listener;
     dirty.container = container;

@@ -1555,7 +1589,7 @@ vfio_device_feature_dma_logging_start_create(VFIOContainer
*container,
      * DMA logging uAPI guarantees to support at least a number of ranges that
      * fits into a single host kernel base page.
      */
-    control->num_ranges = !!tracking->max32 + !!tracking->max64;
+    control->num_ranges = !!tracking->max32 + !!tracking->max64 +
!!tracking->maxpci;
     ranges = g_try_new0(struct vfio_device_feature_dma_logging_range,
                         control->num_ranges);
     if (!ranges) {
@@ -1574,11 +1608,17 @@
vfio_device_feature_dma_logging_start_create(VFIOContainer *container,
     if (tracking->max64) {
         ranges->iova = tracking->min64;
         ranges->length = (tracking->max64 - tracking->min64) + 1;
+        ranges++;
+    }
+    if (tracking->maxpci) {
+        ranges->iova = tracking->minpci;
+        ranges->length = (tracking->maxpci - tracking->minpci) + 1;
     }

     trace_vfio_device_dirty_tracking_start(control->num_ranges,
                                            tracking->min32, tracking->max32,
-                                           tracking->min64, tracking->max64);
+                                           tracking->min64, tracking->max64,
+                                           tracking->minpci, tracking->maxpci);

     return feature;
 }
diff --git a/hw/vfio/trace-events b/hw/vfio/trace-events
index 444c15be47ee..ee5a44893334 100644
--- a/hw/vfio/trace-events
+++ b/hw/vfio/trace-events
@@ -104,7 +104,7 @@ vfio_known_safe_misalignment(const char *name, uint64_t
iova, uint64_t offset_wi
 vfio_listener_region_add_no_dma_map(const char *name, uint64_t iova, uint64_t
size, uint64_t page_size) "Region \"%s\" 0x%"PRIx64" size=0x%"PRIx64" is not
aligned to 0x%"PRIx64" and cannot be mapped for DMA"
 vfio_listener_region_del(uint64_t start, uint64_t end) "region_del 0x%"PRIx64"
- 0x%"PRIx64
 vfio_device_dirty_tracking_update(uint64_t start, uint64_t end, uint64_t min,
uint64_t max) "section 0x%"PRIx64" - 0x%"PRIx64" -> update [0x%"PRIx64" -
0x%"PRIx64"]"
-vfio_device_dirty_tracking_start(int nr_ranges, uint64_t min32, uint64_t max32,
uint64_t min64, uint64_t max64) "nr_ranges %d 32:[0x%"PRIx64" - 0x%"PRIx64"],
64:[0x%"PRIx64" - 0x%"PRIx64"]"
+vfio_device_dirty_tracking_start(int nr_ranges, uint64_t min32, uint64_t max32,
uint64_t min64, uint64_t max64, uint64_t minpci, uint64_t maxpci) "nr_ranges %d
32:[0x%"PRIx64" - 0x%"PRIx64"], 64:[0x%"PRIx64" - 0x%"PRIx64"], pci:[0x%"PRIx64"
- 0x%"PRIx64"]"
 vfio_disconnect_container(int fd) "close container->fd=%d"
 vfio_put_group(int fd) "close group->fd=%d"
 vfio_get_device(const char * name, unsigned int flags, unsigned int
num_regions, unsigned int num_irqs) "Device %s flags: %u, regions: %u, irqs: %u"
--
2.39.3

