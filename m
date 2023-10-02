Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025D67B4B14
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 07:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjJBFPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 01:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjJBFPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 01:15:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45303B7;
        Sun,  1 Oct 2023 22:15:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3924Oqfv018763;
        Mon, 2 Oct 2023 05:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=PExehgR1wwBOl6UdIm+wxgTv8Iuq/E0a8DP0NX+SqCg=;
 b=mvbas8y/ljmwerDFYPyNEamH6rBhOQLdC5zjyZqKAdgjXsoZibEKzd1abPO6FreWyzL8
 CpJBFwdnYhQGXmkwEkc7xpzjYTVSqGmuGBxVMQPPi2QZGcO9NIbVW9bRB6syWVeGn/Wc
 DreyKfNpuIaQ80/7iRPVc+xmDVXUEpSv6qEh/oBzJlonPwE8ukrHzug4KGTJyzub5Erx
 U8LhzTzwpGo67OQ09TPoMwB+iSP1uaIN5Je9HdHYFrFktBNdD25hZqu85E4i/24o47Qf
 l8F5AMzXbK74rzNOotZXA6D7zXp7exb829G13vRTgX3SV+c+mkmDtFl4XZzKqgY+oosk SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea921svg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 05:14:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3921lUhf027318;
        Mon, 2 Oct 2023 05:14:33 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea443tb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 05:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gs8VXIUSG4ms6pnyKEbE/HqZxKTD1KccZiBY/Z95aTqXsAAuhYYkklTKLRvhRO7Qllsbqijj/9k/QnFlLAf8sMHK2d4ukCocU4txkLiFqtCMkyy1NiiwgDerQo0L7RWPffWzL8o0HClxAjAnlLCE+a0CVkRs+kh+NjKBknidOEVeDcbf6kEJthdDGZJvKKr4bg0VGWS78baNpTGIQnlW00aJDWEeH+XB+AMqXWv/8TqII5Ue3kQPFkowKpfW1T/eypUspMLiQkFcI823q8x21+65oz1xN8PjTKIkugLjBhsZTDibcFkPZher/xeDEqY7oBKHQ5kE71hIiqxtxhIMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PExehgR1wwBOl6UdIm+wxgTv8Iuq/E0a8DP0NX+SqCg=;
 b=ZP+0stdGegPU5L4WAM9fO4hsseoUs+KKHZTKpY5uaQkNvXQpmd4zj5k3Jpa9UU5jJPEKgpA82Fz/cLnfrKyZmyzaSyMvNB686J+n5rbVatis/raLtxqvK33xnoP4pBWLVhsMTc2IDOHt4Vnw7wwWbRuiL9jE8CIp5M7ntmT5YI0dBT0y9XuHulmNY1D04N0M8cVkgQu1GqTXAj33K8cgEv2X+Xj2eAywMALfBVDNd8pj+YTxU0utnipiylOJ+1CVMH1zeNAfRuXpi2uBP9YymRZeIF+CwIjQFQeoTX8YwAiUYQDfg+Id14q/CuLSSB8wOpp3akM75LlQRStmrzvugQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PExehgR1wwBOl6UdIm+wxgTv8Iuq/E0a8DP0NX+SqCg=;
 b=VJoT+UfrA87HSjoTLlBcFmGgdDjDp22uX1bFh2/dnDpy8cUZyMgtV5bc2FKzyqtZQOF5Yf58zU9NJzbxKbMAdm5C8/Ee4RnKxzFzzkH47QMb6V95hiwsLdAnivScfJWqEpd9mDp9ZOFJx3Ck9un6lploDP4zsVxeLuQOG+NxigU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.26; Mon, 2 Oct
 2023 05:14:31 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6838.028; Mon, 2 Oct 2023
 05:14:31 +0000
Message-ID: <00fba193-238e-49dc-fdc4-0b93f20569ec@oracle.com>
Date:   Sun, 1 Oct 2023 22:14:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: x86: Refine calculation of guest wall clock to use a
 single TSC read
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>,
        inux-kernel@vger.kernel.org, kvm@vger.kernel.org, sveith@amazon.de
References: <ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CO1PR10MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: 27789b6a-b66a-41e8-a98e-08dbc306752e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zQXN2bjIvQYyf3fa+G2sz9ErvGfGrpEDH+X/6MoR/HRUD3iS1jF/svd0Fj6D9xX9lwMb0V7Bcz0fxwMh/u3JMZNoLfDPciAwT1JqgmzkxbRc7i3fyd7jB62q74m7764KK7JO3onViRk1MrLWvrU/uYDGpKXT3RvqEK27vpzKENEqY27TSvZ1eTCxvG7CSrJqyv829Xh2zrRYJXWu/NyYSvB0ioD4sem2gOLVFB09mLQbZ2nqz3tCJZO92Rxiw1WhO2xcwp9IdifrmRQpDAD/ecYmyCG1U8jSfQN0VDdnqKpEc+hytrP1Rauo0s8Tm+vpMVNuoF/yPDiIXjjJVf6ecCgkj7UT36BnuYREXW38p92GfIwvBGWXnvyjVj0/z3YYM04r2F3OaE1Yb2EPK4TCGt+RAuE2LWwgEsyg7qv21FmIxklEzxm+eC5m2LhrQIHyMiz7x6mQ18zOTsGKQvyLuhtbf5VdDSsiEYw+yxnJcx+nAbczh1uryFD3N+3/9WI0iTSuVjhjDqU4P2rbunIGHZ63UV84VSDTdm7MO5T50lUqiBxOobBsBVfuxkcJSG6jxuPr/GLCNu+atPUpumyQznYHV4Nt8G3oBn6XWWkOPvywAqdo+U2rDc3kl/G+lbkSHdS7W4pOPsduQ1x2NNde3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(136003)(39860400002)(366004)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(66899024)(6512007)(26005)(53546011)(6506007)(66556008)(38100700002)(2616005)(6666004)(54906003)(31696002)(966005)(86362001)(66476007)(478600001)(6916009)(2906002)(83380400001)(7416002)(41300700001)(66946007)(8676002)(8936002)(316002)(44832011)(5660300002)(36756003)(4326008)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ais3VzUxVjNxQXBwSHhsejY3d3liQXhSdHFxVUR6QTdaU0JTSlFicXV3QTE1?=
 =?utf-8?B?S3NxcWM1Q3Z0YnlIUmllUEZSVkxMOXBtNFdsc0E5czlKRTNNTzBCbklMN2hk?=
 =?utf-8?B?djM5aWtsZFR4cFJFZlpIVjJBZFQ3WDZXanVYbGpjM0JndVJjQUk3VWJzWlpV?=
 =?utf-8?B?RENIMlBWamtjMStwWm9tRUpPUWZ1RUk0OFZzQVZtckVrWURTTWtEUU9MenVL?=
 =?utf-8?B?U1hoN2dtemhlWDExVVQvc2hIWEQ3dEdIMkxkY2E4OHoySzhKalcxR0greW5J?=
 =?utf-8?B?ZStNRVFzZWIyc0RIUENtRyt0NzRRYUlGQVJkMVBadlRaTHdYZ0NCc1p5Nmpx?=
 =?utf-8?B?NXErYzZwVGp2bTRxVUVrVW1vVklBWkRoejNYNlE4SjNOUTZVaXNqV0NVd1hW?=
 =?utf-8?B?VVBNR2V4dFRHeWEzc1JZTDZjN3F0VU9zSjBwV2hpRCt0amp4LzVNdTc2eG5J?=
 =?utf-8?B?NTAyMk5IWThuclIwTCtIWmxWYVoyNWRuakw1aUNsaURMWjcxS1RKZlNEM0ls?=
 =?utf-8?B?ejVsREJqbFZ3eEdCNlpWa1UxWlZxVXlzeXFYeVd6OHUycjRrRnR3dkI4WDds?=
 =?utf-8?B?bHRLdG94OWc4T0p5ZEZvZGt6VE5DUEdPLzBlMmxXRUdpUTFWdDBMT2pEZmJF?=
 =?utf-8?B?NE05cU5rVVJFWlp4VTR2Zk9kaVB2UlJTVW5VRWlENmgzbkNGSERtSEM3Q2FJ?=
 =?utf-8?B?eGp2MWpmNlZtWlVnZ3MzWHdXRWZjNUQvOGRBUWhRK2JXUDhoRDQ2Rjk0QUF2?=
 =?utf-8?B?RlR3a044V2ZndGxxWS94V0QrcEhzWlBWLzBuRmNkWnB1NVdoRnppZFhqc2dH?=
 =?utf-8?B?S3cza2x2Q2RCV3QwaWZneWdIYW55V0VITGxJdEF0ZXIwaGI5N25nd3d0aDly?=
 =?utf-8?B?bC9Sb3Ewc050elVCTXVJbTQ4SjA4Sy9tTnNuV1lNeXJvM2FKUUV5ZDRwdWsr?=
 =?utf-8?B?QThKQnpnMGNYeDNtT29ENkczNlBtMWxtSkpkRStSNllYY3gvUUk0SERYYWY5?=
 =?utf-8?B?eVFCUmYvMkVIQTVCcFpzU0RGZlArTlI0Uk5ITm5EYzVUWkcwMnd0MHBRL3Mx?=
 =?utf-8?B?alB0WnA4Ulp5c1p4QVluU0NqV2M4NXRRazR3Sy9WYUJrdVJ1L3VESlRkblpO?=
 =?utf-8?B?eFBRYlc3djZhdVZXZkUwUU1Ob2VMVDJPYjZaVmZWRmo0a1NjMVVnL0dCQStP?=
 =?utf-8?B?S0k3cGRBckhXYzlZSWV3UHBNbEpvR2JzeDMwU0Y0N0hCMVhUUXlzc2R1dWhO?=
 =?utf-8?B?ZjM5ZW5GTlpCbjFRSUVkaWFva3JaSndzSDA3ZGtxRStXbHRzampsa3I2L0Zu?=
 =?utf-8?B?QU5qc3ZaNWtBcGZJeERkajJWU2tvM1VBV0dUNXBlUE1INzdyL3BsMDlVd2R1?=
 =?utf-8?B?TlM4SHdmRzRDVCtIK3pGenp2ZVZ2NnB6d3A5WGdqV0Uwb1RxVWtwWjgvTXhS?=
 =?utf-8?B?NDczK2lEL3BKY1A4Y3BUUUc0OHBOOVNqZlcxelRXYjJNRnJDUFl2Qmx6YWxl?=
 =?utf-8?B?a0g5NE1BZi85OURxYkVZY29PR1FsbDZ2MU54bHlVdUl1ZkZEKzZTcUZrYU9l?=
 =?utf-8?B?a3BCYjY1WTB3RGVSS3ppQmU2eTdUMnVVRHRRRGpYWVEzMXpyM0tFeWY5WjlB?=
 =?utf-8?B?N2hsdWN0UW10eDRGUU1nWjdDeUJtd1pZQVRyU00yaVNTZDJ5VlhXTHB0anI5?=
 =?utf-8?B?Nm5CNVZmL25QL2ZpVDhQM1JvaFJuQmY2Zk5iTGJWTFBxTDhXUVYzL0s4V2FN?=
 =?utf-8?B?T2o3U2VuSzNiY3hPUUFQcUUxYXVSMERNNWVGb1ZuWkpsNlNHMHkyWkVLTHF3?=
 =?utf-8?B?NXRQRDdEM3lRWW50VlBHalJMY3E4WkNUSFk3QWNBUG5IV2ZKWDBYU0xOb3JO?=
 =?utf-8?B?cUtzTDRCWVp6U0g3c005ekVERFFKbXluaVNkWjVmYStRWHRiNDZIQUVLb1g3?=
 =?utf-8?B?bHRBc0RDemJYc2ZWKytlTW1ubTlHUGV0NHhpNWY5d0E0ZjRIVGpaZ3BQdGU3?=
 =?utf-8?B?RythR1Q2bUJ5cFlNRkorZ0F2dzdZZVdHTEtnMjkyT21wS0ZxQTQ4UEtUUDAv?=
 =?utf-8?B?bzRENE9kVFBnb2kyVmZ1bVNiNGJ6VkZTRmJmNXFOQWRHbC95RXQvNXNSVGp5?=
 =?utf-8?Q?tG0bztE6PRYBBKGIQ+6dOydZR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K01LUkRmbW52T3M1MGZNU3VZOE10Y2tmNDdMN1lsMDZDR0tPTFlQY2xnc3RE?=
 =?utf-8?B?MTJBNE52Q0Z0NmdYcE1GT01mcEVnK1F6WElFczZGR1NidVI1ekJ3WjFtSmtQ?=
 =?utf-8?B?cENyMG9EUy9SbG90TUQ0NXRCR1VtK24zcWJxY2RaUWVuZ1RvQ0RKdVdocVAz?=
 =?utf-8?B?NDVhOEdMT1BpZk4zUnZqek1PeGxqQmI5b0IyUUNvaWRtTTZaODBpZ1E0dUEv?=
 =?utf-8?B?REVkc3B6S0VwQlFVT29BRmhtbFUzWWtxSUlRRGZXYm1pcEFWcWhya0VsdGpM?=
 =?utf-8?B?WWE5VHg5dFQrc3Jibitka0JxQjEydVJyV2RCY3JYZXZ2cGxYTVpUcTQxbDhk?=
 =?utf-8?B?VFFwaDd6WkJZNVQ4L0E0ZGFvbnBSL2E0NTVGazJjQWYwb2s5OXNVMFd0bmhB?=
 =?utf-8?B?VzNXbExHRlhUOU53NDVVQzV6SGRLZXJUdXBoL2NRSUo3V3kydTdqRlMyaWNU?=
 =?utf-8?B?WHprNS96QTM5NkJQR2k3eEttMUFWMmpGWkdEcnM2TnpVQm5mR2NKNG9LZmhh?=
 =?utf-8?B?T3hSYkdyZDhXSW1QZEZiaXhrU1RPeEphcThIemkvQkhCWmVDekdRMFVYaTBs?=
 =?utf-8?B?S3B4eDlieEtKMWxZeEFmNFF2dEx2ZWQwaGYzT1hINzJraFQ2NkRnN0dhQ1hP?=
 =?utf-8?B?Nzc4ZSthRnNQK3QvdVFNbHFMUDlrT2J4QUxUblhtT2JYRzZlQkxvcnl4MFM1?=
 =?utf-8?B?alJtaUg0MDFRT1lzVGI2M1R0bHljaXNxZ2JxMlVTU3dkYm95dVZ3QjNGbzd1?=
 =?utf-8?B?TzAzTS8zZW9jWVZBSWtYS0laVWx5WDd1NVdGMFczRFYvL25LM1hxa2Y2RmQw?=
 =?utf-8?B?MmpSWHNpQmMySG05Q3NuTVpsUWh6dGtNUzlhbld4VE1tTDdFQVJaWE9TOU9o?=
 =?utf-8?B?OStwS1QxdlpPeGRFd002QU95bHlac1ZXbS9zM1ZReTNVdS8wdWZGVUtsVVoz?=
 =?utf-8?B?dlBGNnBxSlhkZmZORWlmS1NwUndNZ0FWMloyZ3d2MlMzMFZJUldnNmhCbWhN?=
 =?utf-8?B?QjhTRUpNQ2NZREZPdDhjSTZ0L2xCajZLV21ROEhKdk0wMUNBUHBXTkl4cEF1?=
 =?utf-8?B?TG9UWi9QbEVTQnVRSkJYNzBObkYzdWMxN0tZN0RFRmdEVmRab1ZvMkFGSVJF?=
 =?utf-8?B?bEdaSExKRFdVc3dIWXo1U0thdTB2RmQ2RHhoRlZWV2g3bko4dnhQR0FXM1Fy?=
 =?utf-8?B?NkZVR2VGTVE5Z0RKUEhRUU5oMWJucG5FYVlQKzdaOUFLVjJpNDFscTRzL2hW?=
 =?utf-8?B?VU5vQlRSd2JwZ2hiRzdYYmZBN0c1em11OWxTNmhUcFBIaWFrVk12TlJIdUEx?=
 =?utf-8?B?bWkwK0ZzMkxCU3daTVBjbWRUZmJyNSt6cUZMdDBWWXdRVWo2VXpPM3lQVU0x?=
 =?utf-8?B?KzhxaHp1UmVTem9CQ0FycE9UNUtHcUpHaFMrVXA1eGdUeEw5TXFWZGZSdk1P?=
 =?utf-8?Q?xxo4rAaC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27789b6a-b66a-41e8-a98e-08dbc306752e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 05:14:30.7819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sV6THj41BgYGjZqDrLuN2gt/MzCaZWPVQNLrTpM0WaijDH388T8SBl4nCv6TH2gB/VwYeI5ZrumKgD/zMmWtlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-01_21,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310020041
X-Proofpoint-GUID: e_dqFx6Kdmz_AS2gv65PnsA2fD-I5kg6
X-Proofpoint-ORIG-GUID: e_dqFx6Kdmz_AS2gv65PnsA2fD-I5kg6
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 10/1/23 10:54, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When populating the guest's PV wall clock information, KVM currently does
> a simple 'kvm_get_real_ns() - get_kvmclock_ns(kvm)'. This is an antipattern
> which should be avoided; when working with the relationship between two
> clocks, it's never correct to obtain one of them "now" and then the other
> at a slightly different "now" after an unspecified period of preemption
> (which might not even be under the control of the kernel, if this is an
> L1 hosting an L2 guest under nested virtualization).
> 
> Add a kvm_get_wall_clock_epoch() function to return the guest wall clock
> epoch in nanoseconds using the same method as __get_kvmclock() — by using
> kvm_get_walltime_and_clockread() to calculate both the wall clock and KVM
> clock time from a *single* TSC reading.
> 
> The condition using get_cpu_tsc_khz() is equivalent to the version in
> __get_kvmclock() which separately checks for the CONSTANT_TSC feature or
> the per-CPU cpu_tsc_khz. Which is what get_cpu_tsc_khz() does anyway.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Tested by sticking a printk into it and comparing the values calculated
> by the old and new methods, while running the xen_shinfo_test which
> keeps relocating the shared info and thus rewriting the PV wall clock
> information to it.
> 
> They look sane enough but there's still skew over time (in both of
> them) as the KVM values get adjusted in presumably similarly sloppy
> ways. But we'll get to this. This patch is just the first low hanging

About the "skew over time", would you mean the results of
kvm_get_wall_clock_epoch() keeps changing over time?

Although without testing, I suspect it is because of two reasons:

1. Would you mind explaining what does "as the KVM values get adjusted" mean?

The kvm_get_walltime_and_clockread() call is based host monotonic clock, which
may be adjusted (unlike raw monotonic).


2. The host monotonic clock and kvmclock may use different mult/shift.

The equation is A-B.

A is the current host wall clock, while B is for how long the VM has boot.

A-B will be the wallclock when VM is boot.


A: ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec       --> monotonic clock
B: __pvclock_read_cycles(&hv_clock, host_tsc); --> raw monotonic and kvmclock


The A is from kvm_get_walltime_and_clockread() to get a pair of ns and tsc. It
is based on monotonic clock, e.g., gtod->clock.shift and gtod->clock.mult.

BTW, the master clock is derived from raw monotonic, which uses
gtod->raw_clock.shift and gtod->raw_clock.mult.

However, the incremental between host_tsc and master clock will be based on the
mult/shift from kvmclock (indeed kvm_get_time_scale()).

Ideally, we may expect A and B increase in the same speed. Due to that they may
use different mult/shift/equation, A and B may increase in the different speed.

About the 2nd reason, I have a patch in progress to refresh the master clock
periodically, for the clock drift during CPU hotplug.

https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com/


Please correct me if the above understanding is wrong.

Thank you very much!

Dongli Zhang

> fruit in a quest to eliminate such sloppiness and get to the point
> where we can do live update (pause guests, kexec and resume them again)
> with a *single* cycle of skew. After all, the host TSC is still just as
> trustworthy so there's no excuse for *anything* changing over the
> kexec. Every other clock in the guest should have precisely the *same*
> relationship to the host TSC as it did before the kexec.
> 
>  arch/x86/kvm/x86.c | 60 ++++++++++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/x86.h |  2 ++
>  arch/x86/kvm/xen.c |  4 ++--
>  3 files changed, 57 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 04b57a336b34..625ec4d9281b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2317,14 +2317,9 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_o
>  	if (kvm_write_guest(kvm, wall_clock, &version, sizeof(version)))
>  		return;
>  
> -	/*
> -	 * The guest calculates current wall clock time by adding
> -	 * system time (updated by kvm_guest_time_update below) to the
> -	 * wall clock specified here.  We do the reverse here.
> -	 */
> -	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
> +	wall_nsec = kvm_get_wall_clock_epoch(kvm);
>  
> -	wc.nsec = do_div(wall_nsec, 1000000000);
> +	wc.nsec = do_div(wall_nsec, NSEC_PER_SEC);
>  	wc.sec = (u32)wall_nsec; /* overflow in 2106 guest time */
>  	wc.version = version;
>  
> @@ -3229,6 +3224,57 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	return 0;
>  }
>  
> +uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
> +{
> +	/*
> +	 * The guest calculates current wall clock time by adding
> +	 * system time (updated by kvm_guest_time_update below) to the
> +	 * wall clock specified here.  We do the reverse here.
> +	 */
> +#ifdef CONFIG_X86_64
> +	struct pvclock_vcpu_time_info hv_clock;
> +	struct kvm_arch *ka = &kvm->arch;
> +	unsigned long seq, local_tsc_khz = 0;
> +	struct timespec64 ts;
> +	uint64_t host_tsc;
> +
> +	do {
> +		seq = read_seqcount_begin(&ka->pvclock_sc);
> +
> +		if (!ka->use_master_clock)
> +			break;
> +
> +		/* It all has to happen on the same CPU */
> +		get_cpu();
> +
> +		local_tsc_khz = get_cpu_tsc_khz();
> +
> +		if (local_tsc_khz &&
> +		    !kvm_get_walltime_and_clockread(&ts, &host_tsc))
> +			local_tsc_khz = 0; /* Fall back to old method */
> +
> +		hv_clock.tsc_timestamp = ka->master_cycle_now;
> +		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> +
> +		put_cpu();
> +	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
> +
> +	/*
> +	 * If the conditions were right, and obtaining the wallclock+TSC was
> +	 * successful, calculate the KVM clock at the corresponding time and
> +	 * subtract one from the other to get the epoch in nanoseconds.
> +	 */
> +	if (local_tsc_khz) {
> +		kvm_get_time_scale(NSEC_PER_SEC, local_tsc_khz * 1000LL,
> +				   &hv_clock.tsc_shift,
> +				   &hv_clock.tsc_to_system_mul);
> +		return ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec -
> +			__pvclock_read_cycles(&hv_clock, host_tsc);
> +	}
> +#endif
> +	return ktime_get_real_ns() - get_kvmclock_ns(kvm);
> +}
> +
>  /*
>   * kvmclock updates which are isolated to a given vcpu, such as
>   * vcpu->cpu migration, should not allow system_timestamp from
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c544602d07a3..b21743526011 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -290,6 +290,8 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
>  	return !(kvm->arch.disabled_quirks & quirk);
>  }
>  
> +uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm);
> +
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>  
>  u64 get_kvmclock_ns(struct kvm *kvm);
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 75586da134b3..6bab715be428 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -59,7 +59,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>  		 * This code mirrors kvm_write_wall_clock() except that it writes
>  		 * directly through the pfn cache and doesn't mark the page dirty.
>  		 */
> -		wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
> +		wall_nsec = kvm_get_wall_clock_epoch(kvm);
>  
>  		/* It could be invalid again already, so we need to check */
>  		read_lock_irq(&gpc->lock);
> @@ -98,7 +98,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>  	wc_version = wc->version = (wc->version + 1) | 1;
>  	smp_wmb();
>  
> -	wc->nsec = do_div(wall_nsec,  1000000000);
> +	wc->nsec = do_div(wall_nsec, NSEC_PER_SEC);
>  	wc->sec = (u32)wall_nsec;
>  	*wc_sec_hi = wall_nsec >> 32;
>  	smp_wmb();
