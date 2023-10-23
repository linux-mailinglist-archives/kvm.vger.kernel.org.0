Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5097D40D5
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 22:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjJWUX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 16:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjJWUXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 16:23:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388EC10E;
        Mon, 23 Oct 2023 13:23:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NKIrHF009173;
        Mon, 23 Oct 2023 20:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=y47zLBNnBJDEJTH8RyCAIFhXmXhenl7+XiK2Ox6bjQ4=;
 b=aVsPB04Ei4OstBLsKog4bU8hMtgifQ04xA02bM603Ewljgkghb0WmcQYP8T+QXHCR6G9
 DxefaVI7KhtbGvuNcQ3NlVp0np/uo3BfLDwVK3KbO9RHZ9U+GsLqmNvjjSn68yiaDbUc
 p6dAaS2CIjGK7iRpJWTIJwSx+7Oc5vtnj+KD7SwMJ1853+Az4I6reULBiacrJM77no80
 gC6xF/yXhZ7liumS788ET+OZdUwLXuTtj2m/pRKPlm0NZjwiftTgmx2GYar+GlUy8Jtx
 jsmq8cE88OOjFBA2VQdDON/XA7vzKwuLcslWRUqeuzhnBV87GB/5OZZIBPyQmAVeQrKj RA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68tc1pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 20:23:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NJLXYn019078;
        Mon, 23 Oct 2023 20:23:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv534q3qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 20:23:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SL1OEnoHje+aI7rZBdTwmFM1A1RDAgCIVdLvTWIJjL5VqF+qUTNJ7sObFNWfaCy+eYvj6dpc7B96Cca/OqWu/O3O/YZsX/mlmYllJ0azFeXScoDpT9+AjcvXqrTQZJs1MpSl+KsOfQLky7+N7ytGcYZRJdoUbZlFLjDCyHUvcvE9WO2ogQQXldC6h1VFQ/syHbYiB8R7sac51pSvPMSG6DFkqMOV8TDLHxXTGOEznQ3tr6Ve5c/362NekMMMXB6THEePpIIO6AhdD/XHbqIZto7Fp+n1iRcVBoVJto0gonwJfvloKbRetEtyr3zwJntcY0vXOGYPObok4W56H2Dpjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y47zLBNnBJDEJTH8RyCAIFhXmXhenl7+XiK2Ox6bjQ4=;
 b=BcE5ejuI1O4llGJWDFh7eE6yojRP2DdWHUkQrWxQYVoZ1F2p0tDyToD18xCHoK5zzYnY9lgshM7By0alFi6ifRRVYVb1mZvhudBJ1Hxz8ecszd5lE2z7oV7csU5r4QukiW5yJ0UJswIzAjxJkyDlCSzKN19IxgzRPEbtDk/knMhegQv/+jXTEOYwUr88qHZtYUIIUeV2dmzQ/TW5ChSH8qZB5VZ5WkqARVgBXs9aIeL5mYX8tJu5J8RBQktevCsLpwWTSSJCW14wwbz2RFj5IGVOf2Pxks8QhMnI0UsRkRwy8uwBvRYEjGBY7kNeejQS8UXyBQlN1zYp+o86FfmFKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y47zLBNnBJDEJTH8RyCAIFhXmXhenl7+XiK2Ox6bjQ4=;
 b=yXLCv1Ykv51sK7GVNxk0sdD3LMEBwsd8CCGvUabvg/S7aNDZ/OZzwEioAfWzUkm1q9ToiFVph8BINfE56oNCpFbnmYeUb9UohEuYoCp3PRLzNBOIc7pIZWZs665fW+7der275Fn0CQgLW0gHR4hefNfORvxeB6bpyz4Fjz7Q+9I=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL3PR10MB6068.namprd10.prod.outlook.com (2603:10b6:208:3b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 20:23:23 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 20:23:22 +0000
Message-ID: <725697d0-ffac-4660-b601-bde4a821efd3@oracle.com>
Date:   Mon, 23 Oct 2023 21:23:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        oushixiong <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <20231023131229.GR3952@nvidia.com>
 <3b731349-38e4-43bd-9482-6fe43871b679@oracle.com>
 <1aeb7767-428f-4fbe-8531-c408e580764f@app.fastmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <1aeb7767-428f-4fbe-8531-c408e580764f@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0461.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BL3PR10MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1a3f8f-94a5-4a46-6c33-08dbd405e728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUkM8ANcMz54eoe320Fjxq1PTPcpXuftbDpY6gWWH+zaBhF9kbtslLUBm1ZpKXs98LDYyez8SeWQhGiUrcBUxddVMO/jwKZu+YHvtwSy/aYl9BVNl5iWrGUzDZHcaIwB9jqLusAWEA0nrYnb5ID+o4lap+Es4bXtV8B9s2LS7z80EOslml3ywk9i/eNwNliNcwliU+Zc5V8qO17SyuHpFHcv7b58ChthA2Caa1yjCDPuOfNqI2cIGoMcLcDQ4NkkZl6nLxFT/5texJr7+BlBPZFVZL0c6qvgb/A95Fx4NAio4ZIHZc7Twfm+I4ikMfdN6l5dgg3XSNoYZb7yzUDfBBK2U0OYymKjPMsCiLoH03NGBEsyEUZBNkire54zU3lq5kSFddj8HBceBTEwT6YozONRSGQWNsOENVOqw1aVy3d9dgR8XstdQg3wbHPF0bILKCyWU640TINLz9XMoWa0H3nmvGmnJc2pvzKHO5p2afTC6vjS5W/ZMXQXFKq1Ejly2C77/Yne7n+rSMO0jEDGO/TPCMOuu3K0B03MiR1CKS+scDg0QwiNd9VczZMCFRYr3RgeoqKKJ8MXoaHhnT1MVfM35sNiZv1jQYdfjQgYxOEqvNeoIzXwEJ+vD3M8rk+u2Dfxs9pG7Xej4usPN42qxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(366004)(376002)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(41300700001)(2906002)(38100700002)(66476007)(66556008)(66946007)(316002)(6506007)(54906003)(110136005)(478600001)(53546011)(2616005)(6666004)(83380400001)(6486002)(6512007)(5660300002)(7416002)(36756003)(31696002)(86362001)(8936002)(8676002)(4326008)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NS9vNUQ5UG92TWlZdlMyM2tRbVlxREk5enpXWUNsK0pZNXpzMWdjYVJpMDRq?=
 =?utf-8?B?WnZ4UWZtS25NeGtZdzJUeTdFdXlVOUs3L3EzVGNZSzhlSEJhRmNyTjV4Ympu?=
 =?utf-8?B?RmpKanJHT1VUaFBrMkZKS0VyRHZIaHJJaUErbHhEZHdVbnVUcGtxZjV4T3J4?=
 =?utf-8?B?SDdtZ0hCeThGKzRwcjhidXZsRGV0aVdaSVNTQUZGZ0hWR0VHNnBMQ1oyTGVV?=
 =?utf-8?B?REVWODBQbVJ0TE9nT2x2dVNtTXhBNTFuZWU5SHUrckpCQ2NnZzIwVDBJRHZ4?=
 =?utf-8?B?c3NnOWFPbjVPNzJoaHNvb3c0Q2hSbEd3UDFpTVRXN2t3QW5BcDBkZ1BqNTFn?=
 =?utf-8?B?TEgxalZrOVIwVDUrZmkzOVdqd0lhd3FzY05NeFJVcHlKWW95NVp2N3FTcDZn?=
 =?utf-8?B?ZDVIaG4xaWdkQ2NJMWlMd2loVGtXMGNrNU9YYS80K1RHUDFUcmptV0VHeG02?=
 =?utf-8?B?TFRNQmw3VGZtWTJEd3lwR3Y3YjRKMlBjVGpIZDVya1AwKzNVTnl0VFJVR2JJ?=
 =?utf-8?B?WjZpeUUzUisrZXhzMGhHaFIrZXlTSWR3MzJPL2Q2RHNlWEZXWFgyWE94ZlB4?=
 =?utf-8?B?djliNDRFNmdDekNHaURiOWhLd0s3YVpWMDFrbkwxcDBqNXdWcU14Ylg3a0ZS?=
 =?utf-8?B?K0w3QWphWWFUVm1yNVN6REhLb1BIenI1cnArN243MkZPODBqQmM0OVB1ZUtL?=
 =?utf-8?B?YWhRTVJMWlRUcW5raWxMVDQxVlV4M29OellPVS93M1cwajJ0bERZNm5mMGpV?=
 =?utf-8?B?OTFzNHRZMGlzenk3ZUtDWjlPMEhsZXdDdDlwbmhDamwzRXRPcXlScXFNWDlj?=
 =?utf-8?B?Sm13ZSt0bHZucXNFREhycnBqWS9PdHAxbFBjMEMweXd0V2x5dFJlWlRLU0R2?=
 =?utf-8?B?MmxDemhFZHhNWm9tUk5ENjdYcUlQTUdvbEJRUWsxSUZ1ZDE1M2I3UW5kMlEz?=
 =?utf-8?B?ZXlNbHJ2ZjlVUDd6WUxjYmxXUTlxVk5yaUgyR2cyVDBSbUtOZDBJelRmN2JW?=
 =?utf-8?B?OFd3c0VGelJTN053Snhwb2VxTWxhZGNPci82UlVYWS9ZcVFST2hRUktSR2d2?=
 =?utf-8?B?N2tvYWRtVytGQzh2NktHMXhMZWVLdU1OeDlSSUJSbnlHZ2xCeEtkWW03OVdF?=
 =?utf-8?B?QTZxejZFazArV1dtTm1JbzY4ZTZLeUdCajU0RFRJUDQ4eW9CSnQxWFc1ZDQ4?=
 =?utf-8?B?NmVRSHVEYTdwcHhjZzJqM21Zb3pZckxjQXd4dnVLaDhseWc2bWlLdXAzd1Nj?=
 =?utf-8?B?WmJIcGhFYUZGVXBINGJYTkFWWXZpQTl0WmllWkdHdkFQOVl5QjdFNWUvR0kz?=
 =?utf-8?B?Q3cybkJNRmxUbzlLdEI0MTMyVW5KbU05YnhNRjJNQ2Q0UU85NVVDeENYY3E5?=
 =?utf-8?B?V0QyMys3S1BDNkU4bnQ1NVJVcXdmT2hxWTZoMWRlZUhlUi9Mdmc2cDlSTDZH?=
 =?utf-8?B?Vm9FRTJLdFlHbW9PYUVxbXRVWE5HUVR1WXpWRVdxa0pIdzhKSWR4bDRkc1Bq?=
 =?utf-8?B?WkUyS1Z4Skt0cGV1eXVuSmlwQjdNWVdELzB3cW5kQndPQ2hoNGw0OWtPeStP?=
 =?utf-8?B?ckVWSisxT3Z6WkhhM2xjOHhtTkFXRTJaZ2xJU1F5aitmeEUvb0Y2a0NrVGtF?=
 =?utf-8?B?OWF4SmJmNlZTSlB3UEhmbytpL2VjcHpVeHRPd2hMKzE4Rm50dXNWd0FWWDU1?=
 =?utf-8?B?TmxONjM3aUE4QjVvMkcrZnFqeStFS0ttZDJQdzRzY2w1TzFIWTk0bHg2MXB3?=
 =?utf-8?B?dStpYmtVQ1BFWTlKRjJWWU0wZEtXZlp1K1VIVDNUSHdkQTA3MWJkWDFNYnYx?=
 =?utf-8?B?WEhNbnRsZUZQbFB2a3dKTkMxMjNIOVc0VkMxRy9tNitKVmRDYUE5aC9MYW1Y?=
 =?utf-8?B?TzVrMkJLT3BYYUUwbjBmcG5qQmFvTlJDMkl6dDlwZHVma1QxbDZ6ZHVFMkV3?=
 =?utf-8?B?QzZ0OWRZV1R4VHRobU16UjhQSmhremViQXZsTzFPZCtRRHQvR2tQZGZQcE80?=
 =?utf-8?B?RmgyRGpCWW9XWkdqaldNTURTNTljNmdIMHozb0dhdUF3am1Zb3NUTURpeE14?=
 =?utf-8?B?ZytDQU1QdmRQNlpTZHhUY0RZRHVjTmZvZENLK0pXN0s1MHlzN1M2cW12S3Ax?=
 =?utf-8?B?VVlpSkgyRnZvU3dKSUZmb0VkNUpVT1JGU1lJL2FZSWRaQ2VzYXNPcENjM0x0?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZXUxLzRYZGVQdmxsbUZKWGFsbGhEcDBYTVllaHZmK2lxSys4bi9iZjBad1lj?=
 =?utf-8?B?K21QZzVaZ04ySWdZNTZHSGFnODBMdVNleDVpSVBVRkcrSmY5cERZTEJrUzBK?=
 =?utf-8?B?K0tJeURLeFVtNC9TRTArTDUzNTVwYnkySjg2R0VFZzVTMlpTalpXb0c1VkJm?=
 =?utf-8?B?NEJTdFZXbnpReVgyUURWWS9kZkdmZkJJNlZyTUlYVUdmOVUrZGFpNTZVYnB5?=
 =?utf-8?B?ckRxN3V5UTlwME8xS0k1QXcydU9qN2xVdEs2VnRJRDI0MGxha1NQT1JHaS91?=
 =?utf-8?B?TTg1ZUN3TUh0K0IxMG1rWW4xMHJhRklwSGpWcWJVcW9HSXlybmxkdnVQU0U3?=
 =?utf-8?B?WXFxZVFQWmordTVQSWkzaENhcUZaVDRCdGs1R3JxeE5nckwvMkZZTHZUaUVL?=
 =?utf-8?B?V01LaXUxckxSYVBhL3ppTWVCWC9HVmFOclRJcUpCcWFoUzJEc3BNeStubHNO?=
 =?utf-8?B?cXRxQmZpbzRLK2pPNkxhNHBWMDlSVnA0Y05IYit6ZWJuYmxoakhaYWhtekdn?=
 =?utf-8?B?dW45TWtEYm9tVUVGelBCYkxKMGl4dWc3dTUvT0JtRmNsMzhIL3JWbUxBMGxo?=
 =?utf-8?B?R0ErOGxGUm5laXV2Mk96a2s5Z1R0Q3ZyNURCSFdwQTRtdlE3Zzh6dzgrMEx1?=
 =?utf-8?B?ZnNZTEV6L0tPSHVsTTRaSk8vVGNxc3RFSXlYQzNBWk1CeFRmZTgwWHBhR3dX?=
 =?utf-8?B?V0R4VGZVbXoyTTFLVkYrd2NZSXdwUzNab1JHZ2kzUTRudkgwNmVxRTNLTjlR?=
 =?utf-8?B?ZkVHbUpHc1F6dVVOVE5jM0lpR3RRSlUweW12UGdqdG9zTlRVQmhZUytqckYx?=
 =?utf-8?B?YnNTemhaTnZmNGhqKy9zVEd6cWZRS2p2UTA1RUVLZjFJY2o4VEsycUNGdG13?=
 =?utf-8?B?YjBuWFFEcnpuZERMUHN1UFlsZ25DWTUrWGVjdGxBRk9iVUlrRlFITzUweXYw?=
 =?utf-8?B?UVVyejA2WUFpNkJGekd2dXRoZlp0V3N0bUhBc1RlanlBVEEvbGtkMEQ5Vm11?=
 =?utf-8?B?Ly9CbDloMnJETXhHeFB0RzBPZzZDUG5ZTzFXYkRtbWkvUTFGcUZPQXF2b09B?=
 =?utf-8?B?YTF6MFZ6Z3FoYnZEdTNpdFJXUEx1eFZuOWtCN2VkY1lHWGQ3aVVVR3EwcDJj?=
 =?utf-8?B?MHUrZ3hPL20rYVJkbGV1TGx6bElPUDRLaUJsbHA4UiszZ0Rtbm9hbUJrd1NB?=
 =?utf-8?B?UXJIbTNBQjA0N2pPeG1pUEN1UEJNWGVJTmRzN0RnVzRlZDVQbmdsU1NzSWJW?=
 =?utf-8?B?azlyOFZmSXRRYWtLWndjcTJzaHRiWDFmenltRzFaVDhwcnoxN2ZmTk5HSHRs?=
 =?utf-8?Q?UBFg9d0jkv9Co=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1a3f8f-94a5-4a46-6c33-08dbd405e728
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 20:23:22.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edRPCxDw3XXWfG2H1jvWHSTm2aXZLQsh2lWNKZ8+kZU2eP3t5xLKnZ1Ig4NTkBpjJjWyipPQQhl/vj5IY5W0pJFfz2VldTAK7SpUt8CCgtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_19,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230179
X-Proofpoint-ORIG-GUID: JIno2DIudpHGYT6az1rqAubBjLq-OnKm
X-Proofpoint-GUID: JIno2DIudpHGYT6az1rqAubBjLq-OnKm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/10/2023 19:46, Arnd Bergmann wrote:
> On Mon, Oct 23, 2023, at 19:50, Joao Martins wrote:
>> On 23/10/2023 14:12, Jason Gunthorpe wrote:
>>> On Mon, Oct 23, 2023 at 01:37:28PM +0100, Joao Martins wrote:
>>
>> To be specific what I meant to move is the IOMMUFD_DRIVER kconfig part, not the
>> whole iommufd Kconfig [in the patch introducing the problem] e.g.
>>
>> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
>> index 2b12b583ef4b..5cc869db1b79 100644
>> --- a/drivers/iommu/Kconfig
>> +++ b/drivers/iommu/Kconfig
>> @@ -7,6 +7,10 @@ config IOMMU_IOVA
>>  config IOMMU_API
>>         bool
>>
>> +config IOMMUFD_DRIVER
>> +       bool
>> +       default n
>> +
>>  menuconfig IOMMU_SUPPORT
>>         bool "IOMMU Hardware Support"
>>         depends on MMU
>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
>> index 1fa543204e89..99d4b075df49 100644
>> --- a/drivers/iommu/iommufd/Kconfig
>> +++ b/drivers/iommu/iommufd/Kconfig
>> @@ -11,10 +11,6 @@ config IOMMUFD
>>
>>           If you don't know what to do here, say N.
>>
>> -config IOMMUFD_DRIVER
>> -       bool
>> -       default n
>> -
>>  if IOMMUFD
>>  config IOMMUFD_VFIO_CONTAINER
>>         bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
>>
>> (...) or in alternative, do similar to this patch except that it's:
>>
>> 	select IOMMUFD_DRIVER if IOMMU_SUPPORT
>>
>> In the mlx5/pds vfio drivers.
> 
> If I understand it right, we have two providers (AMD and
> Intel iommu) and two consumers (mlx5 and pds) for this
> interface, so we probably don't want to use 'select' for
> both sides here.
> 
It's not quite one consumes the other.

IOMMU drivers use iova-bitmap, and are providers of the IOMMU support to IOMMUFD
usage.

The mlx5/pds (and VFIO too if either is enabled) consume iova-bitmap (thus
select IOMMUFD_DRIVER where the code is now being moved under) but they aren't
tied to the IOMMU support of it.

This is what we are trying to capture in the kconfig and thus structured it
this way.

> As with CONFIG_IOMMU_API, two two logical options are
> to either have a hidden symbol selected by the providers
> that the consumers depend on, or have a user-visible
> symbol and use 'depends on IOMMUFD_DRIVER' for both
> the providers and the consumers.
> 
> Either way, I think the problem with the warning goes
> away.
> 
>> Perhaps the merging of IOMMU_API with IOMMU_SUPPORT should
>> be best done separately?
> 
> Right, that part should be improved as well, but it's
> not causing other problems at the moment.
> 
>      Arnd
