Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3AD7B5935
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 19:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238709AbjJBRRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 13:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbjJBRRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 13:17:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785CA4;
        Mon,  2 Oct 2023 10:17:38 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 392GDtJ8012525;
        Mon, 2 Oct 2023 17:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=nWHSqe6Zi+BeweT5Cu8HtPK5ltHuTKNQdpx7ZLJnLmU=;
 b=k3Wg2T745eKyFyRKzDxS8IMjm8A5YZstd/0F0sR9ZBfUU88ZOxC1kSQorXSF+IaNBSqE
 62y5ugYm14Az0UUbbSCTispQ2AXiACIwx5p7bAhxOpopjeKiX7ChIbsCZPGLyQQkfYmB
 BS5z+OPjGa7pZSzwu8L5pFFD+RpDpc5VDiQUmi/2Y2wCQNtefWc2rcG6hR8fO4kSXuzC
 Ntb5cXrOLwiKOf+dzMJMGBlwvkolTQvE8f5CUebhuM3kLUY3bGPJMEso6MG+I4rjN/O0
 Tm2CZzBPgY+qSxc0alkWyuksO0VpkoQ0cDSCgf1G+hExWe8wYVtlj/qa8sJa5CgysxIi 6g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebqdu00c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 17:17:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 392Ga9D9002895;
        Mon, 2 Oct 2023 17:17:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea44twk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 17:17:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Il16W424cJqSL8Sv2YjyeUHbGE4EbJysJuIMrTU8Fg4jimQvLdvThIu6un2NHNvHi8jK5+Q3TCzwnC0u919Yddm4Kv1OJU295jNNLjC88Ls5z81Q5aPabDdbrUqbwRiqJ/Em6eRhaZ+wz0tWdX9HLT8gaZNr0l1w43bsjb2j4Uv6dqUt3YKwtv11Fbsgwx2Sk4YlqSP4FVBN3Gwlch8Adxgsg0v//k32LydTZoUjj5QNn4zkwQMyJXTk8yegEWOS70GUzFlEn9jfPIcgYdsKMZwQJNur9S6LCW+F3bzSaf/asYTWgXNfMPYFsdOb+02Ea1sbB471sMYb7OoQeo5pOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWHSqe6Zi+BeweT5Cu8HtPK5ltHuTKNQdpx7ZLJnLmU=;
 b=JluVAQpVXVQ5gsxbb2GohA+TBR1oPIniVbknAlRfRnJ2glGu2oxdhGs9zSvqLbI5M7aJkqT0T8sIYsrKmq/O4zhDQ/ggYS/n2JL2KQBBbFhDxGxO1LzCe3OOU3zmVYCKQ/C6JqSnWKDb8xMCP1oYajHEQMX2mQG/m4FmimE1a6Wsjz6ek0g1JqoyMI3q7dnrFYjTl/1xX06T66glFnsNkGmKoFRbSOYAX2lGtdTuHolTHK2fiw3paL+g4dH9syFgG7osLviw+ESklbhAGhFo6blicS59XcwLn/mksfntrcSuoJvyy0M8WNUmmXJQm7pRwMQgLKf26ZbI4Qs/RhvALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWHSqe6Zi+BeweT5Cu8HtPK5ltHuTKNQdpx7ZLJnLmU=;
 b=PrE/T68P8Ki3kgkV8tEfZ8IS4rGkyTS44XYDnPsM5qCAH59ECMvAAXvSMzcGyv9GIQ7mBNszvY4lbjgvmvtJ/tdS9WIXVuMZiIUTyLMoDCGafqIgIWYeqYz+9xREL6jAxMstDSbLOZf3L/xxOM9C/X2FcxlML9+PI6cMt43mO9k=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB4226.namprd10.prod.outlook.com (2603:10b6:a03:210::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Mon, 2 Oct
 2023 17:17:17 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6838.028; Mon, 2 Oct 2023
 17:17:17 +0000
Message-ID: <a8479764-34a1-334f-3865-c01325d772d9@oracle.com>
Date:   Mon, 2 Oct 2023 10:17:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
 <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
 <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZRrxtagy7vJO5tgU@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::23) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|BY5PR10MB4226:EE_
X-MS-Office365-Filtering-Correlation-Id: 79f21469-6529-4d99-4a61-08dbc36b6d5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjOEOo2UjCuDYEN/uyPRkjgpdMjzM+4biKWqe9Yd4XmecHB1IHEsxWI5Gy8U5Tu8ny7kQK4U9xw1NOsyeBj3ff+vWM9wmT/5212IToXEocNIPTQ5KgQXxfQgz4I41YTfI9V4GAwYkUliGBKNB9Ffl85ZgzBJzw03B9UdZIdeldGK9sofsIuBdemYNMxdGgf0/SO9Wlf6h5HPerf7i/FS574Ljq9w2WOuNYRvuQ8zTaa7FcimSGAVLFGYpsAih9LIDbd279qmqwzRjf+oFIAC/Cukzwt1KVJEKb+KtS6bBU07LK5dQdDxvtmPoF6LXdXWg1RTg71X/G7ufyV6QIHaDAw2l2HrLRGP3JG3BU2z1C6tUUwCOc6bXuCItquU0yHHQuFcIZAhNSpD/LAarr8j/XjdSohoFwKnzDhxFOhRmf1nSG4C8/pcAHP2PD0M2VNa5epcubMCcIPYVvvtnVoyDqQmq4B2Vcs5A/bhIvsag9ePr8m7q49de9sGCbVQR8RDRYYxHk/hg6Hnkzr2WK2e2c6c3tEndfY5E8S4ELvzeltd7J/4QCddYgnLi3utxe63jdGWcDvudEfiLtKCnbB9MudFPY6ND+ImDoh4iIIc08QuiZ3Cdx3uPNOKO9xXnBJczFYxOxggQWUok9i7elRr40QC+0wdCoZIpLv2HE133eBgqaw2T3mLHGx+CR6C209A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(366004)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(7416002)(31686004)(2906002)(15650500001)(44832011)(5660300002)(4326008)(8936002)(8676002)(26005)(2616005)(41300700001)(66476007)(66946007)(316002)(66556008)(36756003)(110136005)(6512007)(6506007)(53546011)(478600001)(6486002)(83380400001)(966005)(31696002)(6666004)(86362001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ZqZkpJOEJpbEE4cTVjK0plOVRBMGhRa0tOSm9BQ2VEYkcrckVsNUZQeFkr?=
 =?utf-8?B?bCtyV0ExbE5PYmZzRmpMMkQxTG8veWlxVG5DU1hYbVd5T2w2emk0b09BbWJj?=
 =?utf-8?B?QjZPdVcxa0JMTnBYcVU3TkdIck5haGw3ajg1Ry9VYkpYVjYrQjJTTUhzS1la?=
 =?utf-8?B?bWhFSUR2UGNCNndJTWEwUHhQaG5VZmlZQmtCUE5XWnRmODVsc3VyWnZoMkFr?=
 =?utf-8?B?V01kUzhtOThlL29mR2FtY0NlL1dUaGd6OXp5U1hlWW4wMGtiQ2tJUnM2ei9Z?=
 =?utf-8?B?c2VsSksyZHd2am1WQU1sNTF4MVVNWUcvZGtLbVc3dWdISDZBS09EMkZFZU1K?=
 =?utf-8?B?bzhUQ1RFbHNmS2NST0dqTWZwQ21RczI2RXlDelFzNDZFeDNsQlpmVS9oRlJq?=
 =?utf-8?B?OTVRa0UvNWxCNU1lM1JjTXhTNXZ4aVhNUkNqaFV4MzdMNlY5UjFIck9TQjdw?=
 =?utf-8?B?bjFWTjFzNzBWdWY1RXlZcDd1T0U3d1NNWDJXelpxcWpWcy9vN1ZmcEhwQ2Q4?=
 =?utf-8?B?R0xncUpEQTdqRDZ4am5PbmUreG9aVnNVaHVsSUlBR2dKNDRLSEJteGlva1VH?=
 =?utf-8?B?c3MyZ3pZZWQ1QVhQK3lVSE96MktpYkdEUlJsN3dLcWRBRDcxK2U5QTNQdmU3?=
 =?utf-8?B?U2R4Qm5SZlVXaERZN0lIaE1hckl0MmxwM1RLZk9qZ2VENkV0RWsydTM2cDlX?=
 =?utf-8?B?b2Q1QTdWelF3Z1BackNHYzNaTWFYdyt6WFVyN2c3TnMyeVgwZEF1ZEVIaWw1?=
 =?utf-8?B?YVlVbmNqcC9Td01sa0FNYWFtSldsM0VWVzRRK1FCNjgxUVpEdHBndDgybmdr?=
 =?utf-8?B?TEcrYjJBZ0JEQjBYYS8yTmxoak5PRlpXY1B1cit0SndGK0owanEwNzM2SGNR?=
 =?utf-8?B?NkVESjVjUWZXWkNnWVVoTlhUYmZKK3JaM3RYb1JCY005OEZBQTdhOTEyT1RP?=
 =?utf-8?B?RkJTbEtBeWc2UGVRRGw4MGU2YkhFcmNXUzBwNmx5SnlsSVVockVZTmZ4b1R3?=
 =?utf-8?B?S3QxSXJYb2UvaDRuQmo0WkNaMS9wVm9aeDhnNWdRWnpHaXBlUWRZN29LQU1B?=
 =?utf-8?B?Q25yaXZmUTI4ajNYZTZzZ1pudkU1ZnErNFdDZ2F6azA3SytPZXBIckhFcENI?=
 =?utf-8?B?TnFoczI3VVdCSUJlbEd3Z2VVYVR6WGo0SUhOMXg0T25LelY0MGpTc0JoU0N5?=
 =?utf-8?B?Rkp3NjFnMEIvQWhJNmpiVXczcCtwNVg5ZGx2WEhyZ1MyaHJUTzQ3aEhuYUV6?=
 =?utf-8?B?REZHL0d6SDFaMjBydFVobTJUOGxvRGo4Z3ZNdzhGYXlpdU9GVEIzTm1ja21U?=
 =?utf-8?B?SUN5MVl5WUg5eS80VTg0UmtXa2ErZzVZU1RaYWw1VkFIM0drZUhCUkdLK0JM?=
 =?utf-8?B?K0xCejJvRUYzZXRRd0NRdnArRnBDeVJqVjFCZS9jenVEamRmdXJaSnNxVWJB?=
 =?utf-8?B?aGU4NXd5UTFLUjNlRzl5WWJaUzlPbGRiN3lENk5DdUVyM2xiOHRjZnJKOEdn?=
 =?utf-8?B?c1V4aEpLOTdKU2NCNnRXSDF4WitjSkcrYXpxZWdhU2YvRzZqei9XbUV3Q1dR?=
 =?utf-8?B?UUtYdE9iZ1BSSXlFMTRHZlp3c0VtQkk5clgyTjRXSU5CQkMwSnNDaXgvSXRW?=
 =?utf-8?B?YXVPaCtBR3c2YmozQVpxWkNDV3ZTd2EwZnZkQjhJM2NvelU3NW1OVHk2U1VO?=
 =?utf-8?B?MU9KaEt3bWZHSEl4VnNVSzRTU1BJSUJkNnNiZFdWV2I4MTR4WFNxWWdoaUlX?=
 =?utf-8?B?blhrRmlud3RWWStZSm50SGdjdzhZcE5JYkM3OEViNS93RHF1MHRzMS84T1B5?=
 =?utf-8?B?WUkrZmhPTjYrZmF6R0V3RUNHU1NYWHNlRCtMQWswcFBNdTMwTi9lYnJTQ216?=
 =?utf-8?B?L2VkVTlwaHBJY0hsdkJWTUZFN3loZkFXUXVyNUFkVnozYTlrenBwQUxPYzM2?=
 =?utf-8?B?SHl4dUdYTUZMaE9aaThMcE1GMWg3TmdGN2lxUjBYSTlhNlEvLzhBcGlySkZJ?=
 =?utf-8?B?eXBobzFhaWFkQ3BneTBBWjZKRTVuMjFxRnFQZWxUQTBxYlNIMW1OZ3gvZWdM?=
 =?utf-8?B?U2hTa2dxeEJxWnMvdEFDbnhZUWxJMDk0OHFJNVBHdGVyc0lvWVhVQ09FdHFD?=
 =?utf-8?Q?n/T862IcOCWH9ymTzKa2p5//q?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RDM0cFdtYUlETWg5Y1Z6WXgxR0thcTUxdGJrN3JNNEc3SDVhS1RyUkxMUXFy?=
 =?utf-8?B?YXlKUUZvZ0NpbHBpZVdEMktPR00xYWNPQ1VJVUlqQmhvbW0rOW85SVNsOG5v?=
 =?utf-8?B?cDJnQThOMzFIUWdsMWJzMlZrdVlVcHpQZ1BiN3lOb2ppYWZmM0kwSmhoYWE5?=
 =?utf-8?B?K2RDNWtIUXBseitENkVhZi9QSUFISTVqUmNNeUhTZTk2WEgzUnhRclErS0Er?=
 =?utf-8?B?c2greWdydSs1WHo4YUp6TEE3QzV1LzJZV2x6TzEzdFhJMjN4c3Y5aDBmMEl0?=
 =?utf-8?B?TU9JN21KTTVOVW95c0ZJQnRKTTh2QVk3UERyN3RsZ25qdmMxU1gzeVhGQXNu?=
 =?utf-8?B?VFdPcHVBUTJQQXMrZUdTNDFYOEtyeTNuRVRCU3owVkt6dmlGOWtqVEVrK1p3?=
 =?utf-8?B?Z3VYV2IxZHlVbDhoMEJ0QVFSZzd5Sk5reDhNU3ZLNEtyUzJVT04vdnMxSGRF?=
 =?utf-8?B?UGhVZnQvRlREWXhZd0JmU08rUUdhT2tXQ1duT3lMSUdOZWg1eW56M2IyWWJz?=
 =?utf-8?B?SElUOG1WMW9OMmZ3N2loR0xSdVIxYnJ2bi9GT0dTcGg0MzdueUxTV2kyRDBQ?=
 =?utf-8?B?STV6azZLZmtxNlZPWUt5MWtCanJLRnVpYTc0Smo4aGtjTXRmN0dBZHFDM3Fy?=
 =?utf-8?B?N3Y4cHUwVFE1Ymd1THlQcHRqc2VkSUtOeklUTEJmRlg0QSt5eXNJRlNqTGox?=
 =?utf-8?B?UXB2enRBdllSOUdWZmtYZmtnR2wrVHVDdi9yN2R1MkF5b0c3Yk5rKzlINXAv?=
 =?utf-8?B?ZXF4MmF2VVgyclMxa2FUa3c2TndZK1MxRVZaWitlV2doQkp1T1FGeVpDWHB3?=
 =?utf-8?B?bWFXbGhJakYybzR0VmltbTR3TmlZU2padVBNUHFRbWNvMDhtNDlnK1ZHYjc3?=
 =?utf-8?B?amUxbXYycDFCN1BmSnNQQ1M4aXNSaWZkVXYrQmM1Q1hQaXprYXlQT2dYb0pN?=
 =?utf-8?B?N3ZxL0xKWi9CNERQc05VOGlNL3l0dzA2N1FkZjR6dGlaVHRtaWxyT1NTT05T?=
 =?utf-8?B?YmhyZ2swY3g5NC9TdzFxTmRneHRhQlhKTlpQb3lpaTBaTFF1NzRBM0lmUy8y?=
 =?utf-8?B?SmdRditDK0VBVnJPY296YXlrWEpncCtZcGt4Q0hOWldQcWRva0NKdjVxS25U?=
 =?utf-8?B?cFI5dmtrSTdwYXBsSXBoUS9TQ1FZQng3TXVhV0tIQXRHRFd0Z2t0eDhRMDlT?=
 =?utf-8?B?ZENvdjJWVjJ5c0RUbFBLL1M0TmxON3hURjRwQXhMUXRPcVdvWkg0QkQ5TzY5?=
 =?utf-8?B?WW8xTExHSlh4SVBFWXNaWnVqZDVCN3c3clU4RzFVU2l1cmVQdUtvSFVIblVx?=
 =?utf-8?Q?iISNgaTYcQJGW3g5h/Nb+TtEja8pSq2mEw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f21469-6529-4d99-4a61-08dbc36b6d5b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 17:17:16.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8ywBQMyq+Mpohcyh6a4lYq4ZYT7n4UpUuQbPL7l0tyMLhQ2uAPFUeQ0xYjcOLpbpRiaTjhXdg2zBtOY6pJ0Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-02_12,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310020133
X-Proofpoint-GUID: 29jJxkjNcIVMBcxECplFV-EnEK-pZhwA
X-Proofpoint-ORIG-GUID: 29jJxkjNcIVMBcxECplFV-EnEK-pZhwA
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean and David,

On 10/2/23 09:37, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, David Woodhouse wrote:
>> On Fri, 2023-09-29 at 13:15 -0700, Dongli Zhang wrote:
>>>
>>>
>>> We want more frequent KVM_REQ_MASTERCLOCK_UPDATE.
>>>
>>> This is because:
>>>
>>> 1. The vcpu->hv_clock (kvmclock) is based on its own mult/shift/equation.
>>>
>>> 2. The raw monotonic (tsc_clocksource) uses different mult/shift/equation.
>>>
>>> 3. As a result, given the same rdtsc, kvmclock and raw monotonic may return
>>> different results (this is expected because they have different
>>> mult/shift/equation).
>>>
>>> 4. However, the base in  kvmclock calculation (tsc_timestamp and system_time)
>>> are derived from raw monotonic clock (master clock)
>>
>> That just seems wrong. I don't mean that you're incorrect; it seems
>> *morally* wrong.
>>
>> In a system with X86_FEATURE_CONSTANT_TSC, why would KVM choose to use
>> a *different* mult/shift/equation (your #1) to convert TSC ticks to
>> nanoseconds than the host CLOCK_MONOTONIC_RAW does (your #2).
>>
>> I understand that KVM can't track the host's CLOCK_MONOTONIC, as it's
>> adjusted by NTP. But CLOCK_MONOTONIC_RAW is supposed to be consistent.
>>
>> Fix that, and the whole problem goes away, doesn't it?
>>
>> What am I missing here, that means we can't do that?
> 
> I believe the answer is that "struct pvclock_vcpu_time_info" and its math are
> ABI between KVM and KVM guests.
> 
> Like many of the older bits of KVM, my guess is that KVM's behavior is the product
> of making things kinda sorta work with old hardware, i.e. was probably the least
> awful solution in the days before constant TSCs, but is completely nonsensical on
> modern hardware.
> 
>> Alternatively... with X86_FEATURE_CONSTANT_TSC, why do the sync at all?
>> If KVM wants to decide that the TSC runs at a different frequency to
>> the frequency that the host uses for CLOCK_MONOTONIC_RAW, why can't KVM
>> just *stick* to that?
> 
> Yeah, bouncing around guest time when the TSC is constant seems counterproductive.
> 
> However, why does any of this matter if the host has a constant TSC?  If that's
> the case, a sane setup will expose a constant TSC to the guest and the guest will
> use the TSC instead of kvmclock for the guest clocksource.
> 
> Dongli, is this for long-lived "legacy" guests that were created on hosts without
> a constant TSC?  If not, then why is kvmclock being used?  Or heaven forbid, are
> you running on hardware without a constant TSC? :-)

This is for test guests, and the host has all of below:

tsc, rdtscp, constant_tsc, nonstop_tsc, tsc_deadline_timer, tsc_adjust


A clocksource is used for two things.


1. current_clocksource. Yes, I agree we should always use tsc on modern hardware.

Do we need to update the documentation to always suggest TSC when it is
constant, as I believe many users still prefer pv clock than tsc?

Thanks to tsc ratio scaling, the live migration will not impact tsc.

From the source code, the rating of kvm-clock is still higher than tsc.

BTW., how about to decrease the rating if guest detects constant tsc?

166 struct clocksource kvm_clock = {
167         .name   = "kvm-clock",
168         .read   = kvm_clock_get_cycles,
169         .rating = 400,
170         .mask   = CLOCKSOURCE_MASK(64),
171         .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
172         .enable = kvm_cs_enable,
173 };

1196 static struct clocksource clocksource_tsc = {
1197         .name                   = "tsc",
1198         .rating                 = 300,
1199         .read                   = read_tsc,


2. The sched_clock.

The scheduling is impacted if there is big drift.

Fortunately, according to my general test (without RT requirement), the impact
is trivial unless the two masterclock *updates* are between a super long period.

In the past, the scheduling was impacted a lot when the masterclock was still
based on monotonic (not raw).

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53fafdbb8b21fa99dfd8376ca056bffde8cafc11


Unfortunately, the "no-kvmclock" kernel parameter disables all pv clock
operations (not only sched_clock), e.g., after line 300.

296 void __init kvmclock_init(void)
297 {
298         u8 flags;
299
300         if (!kvm_para_available() || !kvmclock)
301                 return;
302
303         if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
304                 msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW;
305                 msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW;
306         } else if (!kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
307                 return;
308         }
309
310         if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
311                               kvmclock_setup_percpu, NULL) < 0) {
312                 return;
313         }
314
315         pr_info("kvm-clock: Using msrs %x and %x",
316                 msr_kvm_system_time, msr_kvm_wall_clock);
317
318         this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
319         kvm_register_clock("primary cpu clock");
320         pvclock_set_pvti_cpu0_va(hv_clock_boot);
321
322         if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
323                 pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
324
325         flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
326         kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
327
328         x86_platform.calibrate_tsc = kvm_get_tsc_khz;
329         x86_platform.calibrate_cpu = kvm_get_tsc_khz;
330         x86_platform.get_wallclock = kvm_get_wallclock;
331         x86_platform.set_wallclock = kvm_set_wallclock;
332 #ifdef CONFIG_X86_LOCAL_APIC
333         x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
334 #endif
335         x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
336         x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
337         kvm_get_preset_lpj();


Should I introduce a new param to disable no-kvm-sched-clock only, or to
introduce a new param to allow the selection of sched_clock?


Those may not resolve the issue in another thread. (I guess there is a chance
that to refresh the masterclock may reduce the drift in that case, although
never tried)

https://lore.kernel.org/all/00fba193-238e-49dc-fdc4-0b93f20569ec@oracle.com/

Thank you very much!

Dongli Zhang

> 
> Not saying we shouldn't sanitize the kvmclock behavior, but knowing the exact
> problematic configuration(s) will help us make a better decision on how to fix
> the mess.
