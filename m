Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F003735D03
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjFSRZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSRZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 13:25:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13FDB2
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 10:25:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J9nZ2o013645;
        Mon, 19 Jun 2023 17:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8+pxZZuu8A/uaazVdGSFd/L+goF+KhNbhECCXBjCpX8=;
 b=jmcm2C55XkGRU8glFbHGeT1PyCY8/kmhZx4cF1pMGxRD+mYXbuwrnwDJJC+N2Z2b00Xw
 /ri7LD2/j6/jgfv+6niziHDVM2DhplGFJa8xMQchrA8uFTMf4xXDeeSUqtO+f5P2Hi1k
 uxwwBPSnp34mSsgc+H2+htpln4iBdQhEkhzT0E7Bdhl3+pP7CDz2l7aEOLXZTbBGMMPo
 byUpd1hK4+e4maEaOqr3ew8JAwKl8APm0EqmlQo1bnsJZyTc7J1Hd4iW+IEnNGiuCNS9
 +sq3z4nFyFc5QmS6e1k7IbKL8gX/KhqnNCXmB9YWGs1XqoOhxQZLLv0uMF0JnnBL/ghF pA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r94qa33cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 17:25:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35JFXfgS038637;
        Mon, 19 Jun 2023 17:25:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9393ng1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 17:25:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUrTu0/rDTfx+sVfnxEIJwd95myr+nJePkmGKRWSXdYQcAZjTeuYUfqyVSvMTD8ejNTYbi/Ub+Q5Z/vN9ukxgOx8gUASgPdbuvt8Wvn7F+UNSN8EyohS0NNkjkX0hkwAGRimOXLGrD+i/skmpN9mxMluogsmed1Dh+WKJlfZUYtUoHRzrBCjkApDp8OIOHZGb6UF1pXFYB3Ndlio48ec7I4Z1eViPCyfU2HkOgMdFNajpcWqbGdjJNtAvOAZBbfJXEGSRWXC3FozzjuGlrf247BsYfsZ6mIhnu3fr2PmhueZJtk1qZShWmoeKttNdzkA6ya06nY3Fw5WhZ++LTXTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+pxZZuu8A/uaazVdGSFd/L+goF+KhNbhECCXBjCpX8=;
 b=EVIbFc7iZ6pHvkP/Voys5J1pzO7glKOgI1P+2Vms/aJ9/amosTCYFdNR7lrIrjGTCueGAjWSYzb/MU5NMMt/Su5dc+fn4JgJ31nt6fyhyBocqaKLEWf35eVDD0cy4NiZ4Yr08uS9uVIM1/CQstTlqDlkbr/w38l2gMPBQKZMX6wwHv1TWZwJ7cxcl9PAxjIxVUMCtXWhKNKrjdqWaSSvIGKubawE+JPF8jzk/3dpQywGXIaPrDA744ZLRPchgrYfJne1O3aTT+rl9r+QhhrOZPDb90XxP1b3KtShXNrHtpOb+AWznS1Z9d01eTfyncYeru0hXPIiDMg4yz7h/uqcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+pxZZuu8A/uaazVdGSFd/L+goF+KhNbhECCXBjCpX8=;
 b=reAoUbOwlrPm2uus7tlwCTfuimde1BlUmE8esoxqq9b6RPYz/N+cyibVKC8JRNYWvPAbgYcZ3iJKlYLCZomHnwYLRIabOAeuLsHZm3g99zZkm3ayHHc9fiYK8NkgK1DOz3U57EEVyJa4jgTL7n2XsTJ9ujz+jntlroLW15nmmOo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by IA1PR10MB7386.namprd10.prod.outlook.com (2603:10b6:208:42e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 17:25:16 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 17:25:22 +0000
Message-ID: <13b5f736-6ddd-cfc1-d861-fa9063943029@oracle.com>
Date:   Mon, 19 Jun 2023 10:25:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/2] target/i386/kvm: fix two svm pmu virtualization
 bugs
To:     Like Xu <like.xu.linux@gmail.com>, zhenyuw@linux.intel.com
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        groug@kaod.org, lyan@digitalocean.com, qemu-devel@nongnu.org,
        kvm list <kvm@vger.kernel.org>
References: <20221202002256.39243-1-dongli.zhang@oracle.com>
 <895f5505-db8c-afa4-bfb1-26ecbe27690a@oracle.com>
 <eea7b6ba-c0bd-8a1e-b2a8-2f08c954628b@oracle.com>
 <36d749a2-b349-e5f4-3683-a4d595bafec9@gmail.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <36d749a2-b349-e5f4-3683-a4d595bafec9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:217::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|IA1PR10MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f5a34c1-de04-4641-010c-08db70ea297d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxFhkLb/yyd2LzcY3MxOQDlZ8zLqO/dWYMFqB+PggJZWiqv4YqOkq+AJ52KwvAV0+oPRD9LYQzWTa36Mx334+8DFfh4PA67WF3N4YjiQ0QeHdmH7zskfaic/JYvlZRKetJkiCQ/kL4zkJ83+tRq5/+ANxzZ8ABSRvOAplkvUI0fWHpBpZzX55l4qV7x8M/pTBKfkw0cUMZ0/pWk9RRtuqzyjg5ImwTuiKkVeqc/+5cjC8gDZdFlGTE9ieHJ83yLpFFDK0sUf5e16nOJOPlwk50EAJkSUCmZ1Bj5ouo6tjswOts+1XClaHiTG05XeEBR3qemnsvsO8zb9OVt7iD/oNqU0TrYTWPCX78+n5pYmzMFfPQ99ghXpybfYTLsrVlOyZS0CkGbLdY3Ap3ZDFm6qWyzcik9K58fAUyWbTS+nG4lGZPN3tBTwXFojiGutnlXqtnC3mbSyFAkNUdKQlFvRMg+xXSNU8vvdPEKZ0f1BNQXbViEWbuVfseFz7aF5PBq45lw+zAljVlceFgaOEeAEzvu16cOXeTCEOrMWUxZj5k0OfLeSSgzOUGtnBtm1x8auY1p267yFhHNj8hLzeohCPNrFquHiEEtlgkchJUTCkEYO9YCKYg7t3fkGtzLR5/W6sCriCKrDberZEz2Xq4AtImNe7ZPIoBwNIFeCYg65xCYkLr3kiA5sJ86z3f8EBEw8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(2616005)(83380400001)(31696002)(86362001)(44832011)(31686004)(2906002)(5660300002)(4326008)(66556008)(186003)(66946007)(8936002)(8676002)(66476007)(26005)(966005)(478600001)(38100700002)(36756003)(41300700001)(53546011)(6506007)(6512007)(6486002)(6666004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THVQWllMemx4VWVqNFI2WDZDTkhQUm5GWG1tT0tnanl4bEhlcXIybUgxcVBu?=
 =?utf-8?B?aTRZcSs0R2xxOTFXS3B5c0VPZkM0VUpQdExFMnVoMERlSjhZZHpJRFJpTmps?=
 =?utf-8?B?TitkdUl0bE8rTkZ6T3lkelhnY0IvZFRDS3UvMTVlSG9hYzBLQ1VNZjZPN0c1?=
 =?utf-8?B?R0ZIMm9EVEliVnlGV1FlWGdlZGV2S2dGbitBczJOV3RyZVRkeStxSk9lSmVy?=
 =?utf-8?B?T0hKUnBZVEdKY1d1cEJzR1hiRDZMaHBpNTloTTFxckw1SzVYaUJXVkxFcDVi?=
 =?utf-8?B?QlhTOGV1clRIdjZrMmhwUENmKzUwVTR1WTdRcGJRellUeDQ0d2xzaGJzMHFJ?=
 =?utf-8?B?OThVdkhSKy85YmVqVmJCWkxJbWtpWDRWbllYMEdmWDJrQUZqTExraEhLY2Ns?=
 =?utf-8?B?Q0kwT3oyQzdrTHV3MUY3dExuUFZjNDFFL0lYM09XQ1BNMlBpL3FIclZPbm9s?=
 =?utf-8?B?MHRQdXJDUjBNZnBEdjRCMEp3NGZRR3l1dnBFcFJPTGJEWnlXUnk1K09SaUt4?=
 =?utf-8?B?bG8yZVY5NXNtaVIwYU5aVnRpdHd6TGNuR3liL3BRcGZ4dFFNQ3lma25RZUtK?=
 =?utf-8?B?ZU0wSEJjS1l0cmg4aFJZcVlBWXQ2WW1yZDhyN3k2dVZ5ZUx6V1RhNXhaUk5j?=
 =?utf-8?B?WENsNXhJejdTYysvVGQvWjF5Q2FadDl6eERrN0s3S1dUdVgzWWI2dUxWSHla?=
 =?utf-8?B?QnJuWkJ4Y1lvWWE3NHY0SDZKYXpmMEp1Sk0xOUMxLy9lT240N3krcGVIWmRo?=
 =?utf-8?B?aWlkTzdIVFVwWmtqcXFXUTFjTEovbUI3dmNlZVFaSGFlSXBXc28xL3NwRXpY?=
 =?utf-8?B?dlNEVk1iU1orNjV5YWxnQWxZN3ducTdLai9yKytIWG5UR09iNUlLWXJ6cUt2?=
 =?utf-8?B?YXJUWWM2YjFwaHAyMmpGTTg2eXhBSGltWHZzcFppWWpESzAzRTNIMGE4dm82?=
 =?utf-8?B?SFlYMEQzVFM5c3Rwcms5bkJCUzIxb00veUpNY3k2WWtnZEdCSGI3Vkh4dUpX?=
 =?utf-8?B?amNVRXdOWnNWcXROK0hodFBPdHZXbUVsZVNwL3hwTkc3cEU4dzVtVFR1TDJP?=
 =?utf-8?B?cWJFcjBrRGxjVlAybFY4S3FiUmoxeW82MWZ5cS8wZGJJODllZUN5V2syRElo?=
 =?utf-8?B?bFBpSkwvd1ROeEQ5bEtrSHpYbmY1Q0FzQkhFUmg0eWtSVFRKbU5CZ2t4Kzk5?=
 =?utf-8?B?Wnh0bUxwajFuM2duUmYrbWNPSjAzQTZKZDVVaGhxTU5SU2lWZTlqU0pLUjcx?=
 =?utf-8?B?TmFSeDJmbXlwZTVrdzlSOVhyaWFVUHBzcUJTZ09Rc0VQNU5DTUg0c3dnSDNC?=
 =?utf-8?B?TzJ6Rk0rRFM0ajlmVm5NT0FvRGVkOXQ5aW9NVHdzc1NyV3phc0U4bHZObEhP?=
 =?utf-8?B?NHMxTzc3SDVBYzRuSDlSZm91UlRBSWxMc3JBL3paZGVMOS9lOEhIUXo0M3Jn?=
 =?utf-8?B?UmRON2tpQ2Q1MmJQYXoyMVZKN0MyKzRPeS9QZHpJL2MwdDQrQ3RBYmExM3VK?=
 =?utf-8?B?WXk2L0tIem16QlJwaVY3eXRjaEVhNVp2WEV1dU9QdnZ5dnRjL1N2VnVxdFN4?=
 =?utf-8?B?ZkVqbEkrbmRDL2dDZlJUeVp6QmlCVWdycnFxNWorUy9SQnlvbXF3QnAzVlg4?=
 =?utf-8?B?eDRHajRPbGNzeGhxWU9UM1R1Q0lnK1gzaWg1bFZaNU9sa085dTByaFYwMy9X?=
 =?utf-8?B?dlFxMkJGMG0vQVNCVFYvcmcwbUdXR1hJLzd2QVBLMGtzNlQwNkhLV25sVDFC?=
 =?utf-8?B?MUlaRHl1MUFpQ1NqamZwK1ZxbXo2Qit3aGJqYmJlQWUydHNUaEpZNlk3R0NY?=
 =?utf-8?B?R0hhYlp2RDBuNnFGQVBDelM3Qi9nbG1VakVIdW0wc1FPNFRMdnduV0ZyWGt4?=
 =?utf-8?B?eEJsazhJNU82NENGS3hoU3ovZml3VFcrbU84NGxDRnlVbkFOenFnaEZ2TjFS?=
 =?utf-8?B?UktTV1F1U012NUFaM2k5M1g4SVF5SFVwN0t1dmx5QjZHaEhZQWZDcTZNZEdK?=
 =?utf-8?B?WEErZitsUzlkR1phZEpkZFFUNmNNOG5nenphK0g5VzIzLzQ0T0hyZUJnWWpN?=
 =?utf-8?B?WGlIOVArR2s1aTVvbytlU2hQWTJZbWpBWXNXb3Z3Sm8rN2pEWXQ1eFVjNUlm?=
 =?utf-8?Q?Sw/3MX5OSorTVvRuWzgQimA7c?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cVhVbldmc2dBai9CVG1LaXhQWnhDV0NycTlWV0ZjRG1zZGdyMjRYeTJMWnAv?=
 =?utf-8?B?aDlHQ1FtMERqUjQ1YkNWMDhuSStmbWRxM0VLN25oOWJiTTJGYllIU210QXI3?=
 =?utf-8?B?WEliMko0TFlRQWxmcFFPU3E0dVkvcUlONnFtZ3dwbFNUN0JKbHJTZXFLSkZT?=
 =?utf-8?B?TnBSTUlOdHByalliZmU0NHNJaTZ2TVpMOGJTZW9XdzFXZjk3K3Jlak9QUmVN?=
 =?utf-8?B?ODdzalJGM0JBbXdrSTE0T3JoWFZQQXExRWQvdnJndmR0bkcyUHg5ZGJHSXYv?=
 =?utf-8?B?MmM0bTFrWlZaK21TSmd3Zk0xdk13RUQxWGV1dDFXUVV1eU5uTWFRODRPcVdC?=
 =?utf-8?B?bXFYYTc0OHY0aTBLczF6OGZKbHp1alZaa2xGZkYvMW5kME96OUd3WnROczVZ?=
 =?utf-8?B?SkwvcnBiRjMrak5sVDBDdUxuMnNDV1NyQjIrT2FXcEFoVGJZSU1GbkMxaXJH?=
 =?utf-8?B?Qit4OVFjU0I3UWRISE5ROGdrT2doWHBoVzY2dHM1OW1SVVJkQVhjK1pEMjY2?=
 =?utf-8?B?VnZZSy8rd3BjM240N2JST2Y5dXBtZFl6VFlqTXpsK0xLdUozcXBRNVJnOTJO?=
 =?utf-8?B?ZS9FRnBUWHY4SGZ4Ry9YK3ZHT0dablFpUExHbVJPSFdEMkdBZHlreGx5VFda?=
 =?utf-8?B?QlJTbUttN3VKMDM2MnFhenRpblZqT1BQaDdWTlF6VzFiWjg1MVYrbzRQS1lD?=
 =?utf-8?B?ekFHa1dxLzRtZm9kbmRmVzdZWmxHU3hyMVFUc1drdmgvdDhtM0pxZnYxTkgr?=
 =?utf-8?B?K0wyRExvd0VGbEl3YVU0ZHR6NFRDNDlwOTR6b0liblNpb3A0eUNrZDE3eGJx?=
 =?utf-8?B?RG5KRUdkQlF6andkUjJGOU94ZlVSY25LZWo3bEhiK1pQZ3JlbmdDeW55N0ln?=
 =?utf-8?B?cU9oUmxQZTB0eUYzSFUrcHdQMUxsdVFjamRDbHQ1dTc2U0lSTklXaEM4azdq?=
 =?utf-8?B?UnJsZ3BMWXZxdGlxT25CamV0TDFaSVRkd0ZKUjBadDg1UnljZytsbHBMM0Za?=
 =?utf-8?B?bFpNOFRWUlhDdTJSWE1HWE93ZWxYUnlWOUdQYmV0RU5NWWxMWUcxdVhRZS84?=
 =?utf-8?B?T0ZvU3JITXZSV3JMVVJWdEVnNjFGMmQzZi9OZVdveDlOOUZ5by94RjdyUGxa?=
 =?utf-8?B?eU1rQUVZd0JuNmFJQkVxRmVsbWpOS2dYNlEyeUZ1Ykg4cGs2bVozZGFYb2w0?=
 =?utf-8?B?eXRyeUlkbGhFRmVEUncvTWw1dzgyejdEcU9sYWhpcVZaWE8zWEpiVWxGNjBN?=
 =?utf-8?B?TFcwUjc1U3BHZmlWNWlPZ1o3THc4THhQZUVzL1BpNEp4eWxQUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5a34c1-de04-4641-010c-08db70ea297d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 17:25:22.5159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0ToDqKR55lm9V8becwAApN/20W5eMrxjQhtsZEbLHkElkmZJUacoQQkaJYtIxqKWwPR6LV6uxXYqFN9jlgYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_11,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306190160
X-Proofpoint-GUID: sUw21IhFeGdss1SQUAsVhAV_9gAR6NCb
X-Proofpoint-ORIG-GUID: sUw21IhFeGdss1SQUAsVhAV_9gAR6NCb
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like and zhenyu,

Thank you very much! That will be very helpful.

In order to help the review, I will rebase the patchset on top of the most
recent QEMU.

Thank you very much!

Dongli Zhang

On 6/19/23 01:52, Like Xu wrote:
> I think we've been stuck here too long. Sorry Dongli.
> 
> +zhenyu, could you get someone to follow up on this, or I will start working on
> that.
> 
> On 9/1/2023 9:19 am, Dongli Zhang wrote:
>> Ping?
>>
>> About [PATCH v2 2/2], the bad thing is that the customer will not be able to
>> notice the issue, that is, the "Broken BIOS detected" in dmesg, immediately.
>>
>> As a result, the customer VM many panic randomly anytime in the future (once
>> issue is encountered) if "/proc/sys/kernel/unknown_nmi_panic" is enabled.
>>
>> Thank you very much!
>>
>> Dongli Zhang
>>
>> On 12/19/22 06:45, Dongli Zhang wrote:
>>> Can I get feedback for this patchset, especially the [PATCH v2 2/2]?
>>>
>>> About the [PATCH v2 2/2], currently the issue impacts the usage of PMUs on AMD
>>> VM, especially the below case:
>>>
>>> 1. Enable panic on nmi.
>>> 2. Use perf to monitor the performance of VM. Although without a test, I think
>>> the nmi watchdog has the same effect.
>>> 3. A sudden system reset, or a kernel panic (kdump/kexec).
>>> 4. After reboot, there will be random unknown NMI.
>>> 5. Unfortunately, the "panic on nmi" may panic the VM randomly at any time.
>>>
>>> Thank you very much!
>>>
>>> Dongli Zhang
>>>
>>> On 12/1/22 16:22, Dongli Zhang wrote:
>>>> This patchset is to fix two svm pmu virtualization bugs, x86 only.
>>>>
>>>> version 1:
>>>> https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/
>>>>
>>>> 1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.
>>>>
>>>> To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
>>>> virtualization. There is still below at the VM linux side ...
>>>>
>>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>>
>>>> ... although we expect something like below.
>>>>
>>>> [    0.596381] Performance Events: PMU not available due to virtualization,
>>>> using software events only.
>>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>>
>>>> The 1st patch has introduced a new x86 only accel/kvm property
>>>> "pmu-cap-disabled=true" to disable the pmu virtualization via
>>>> KVM_PMU_CAP_DISABLE.
>>>>
>>>> I considered 'KVM_X86_SET_MSR_FILTER' initially before patchset v1.
>>>> Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
>>>> finally used the latter because it is easier to use.
>>>>
>>>>
>>>> 2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
>>>> at the KVM side may inject random unwanted/unknown NMIs to the VM.
>>>>
>>>> The svm pmu registers are not reset during QEMU system_reset.
>>>>
>>>> (1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
>>>> is running "perf top". The pmu registers are not disabled gracefully.
>>>>
>>>> (2). Although the x86_cpu_reset() resets many registers to zero, the
>>>> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
>>>> some pmu events are still enabled at the KVM side.
>>>>
>>>> (3). The KVM pmc_speculative_in_use() always returns true so that the events
>>>> will not be reclaimed. The kvm_pmc->perf_event is still active.
>>>>
>>>> (4). After the reboot, the VM kernel reports below error:
>>>>
>>>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS
>>>> detected, complain to your hardware vendor.
>>>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR
>>>> c0010200 is 530076)
>>>>
>>>> (5). In a worse case, the active kvm_pmc->perf_event is still able to
>>>> inject unknown NMIs randomly to the VM kernel.
>>>>
>>>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>>>
>>>> The 2nd patch is to fix the issue by resetting AMD pmu registers as well as
>>>> Intel registers.
>>>>
>>>>
>>>> This patchset does not cover PerfMonV2, until the below patchset is merged
>>>> into the KVM side.
>>>>
>>>> [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
>>>> https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/
>>>>
>>>>
>>>> Dongli Zhang (2):
>>>>        target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
>>>>        target/i386/kvm: get and put AMD pmu registers
>>>>
>>>>   accel/kvm/kvm-all.c      |   1 +
>>>>   include/sysemu/kvm_int.h |   1 +
>>>>   qemu-options.hx          |   7 +++
>>>>   target/i386/cpu.h        |   5 ++
>>>>   target/i386/kvm/kvm.c    | 129 +++++++++++++++++++++++++++++++++++++++++-
>>>>   5 files changed, 141 insertions(+), 2 deletions(-)
>>>>
>>>> Thank you very much!
>>>>
>>>> Dongli Zhang
>>>>
>>>>
>>
>>
