Return-Path: <kvm+bounces-1093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D18747E4C74
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A1A41C20CC6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 23:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8285C3066B;
	Tue,  7 Nov 2023 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xLuO+q0i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eruwY163"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5792A210B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 23:08:16 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42AD10C8;
	Tue,  7 Nov 2023 15:08:15 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LK6Lo026463;
	Tue, 7 Nov 2023 23:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=lgMopSjinU9hdsxBVqFmsoZ7uZks6jD68b9bm9USWio=;
 b=xLuO+q0iIctik1uyjTsg7Hu9GxPXgeQWILLGZT/NGnROzD5Gh0QLwvRhR4fYwbnJgbnc
 2oJ+lWbY98k0xIk/Ick4klInIcbPEyzDIAaxbG17kKbOVZW646PKoXSvlv4eM7EGUmMp
 8o9WZz5clJ1Sa31Awkc3KWWIbD82DpyMahM45M+ojhbRWJw3G580sYqMzLXstkfS7Agl
 ptKxs1vvhAlnAwzuoPkLyV0hWLH/NWf/PSu/ynuBYkUphzNJLRHEyMd7F2j0cFcTq9H7
 dkOfNblVedM0RVa81CcAVD+az85Gx7fFtCTkwmSz1JjGk49VuClqVjsRa7CHYnFjM9H2 7Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w2106u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Nov 2023 23:07:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7N24GQ011049;
	Tue, 7 Nov 2023 23:07:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1tv8c1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Nov 2023 23:07:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFh+XMMex3r6elamzAB17Tp2MtSiA3G0JLHl9S6kkJMErtLIjspVWM3oXSwEIAmXNb785T8OYGqmtb+wX5MuX9Mw3DzPXWWzWO1xBInbx0mwdSJclf+to/L+uNNq2+pPZhvSTAUQwYiJv97kUNFQ5Klav8+0BSN+Y75W6wvK8MZzfc4SqJ+6BdXGmSZ/U1WoBJJHG8+Ai4KoH1xXTocbvTCoORGzVPH2oanDhYG1u8TfHPNnhjjo5s6YkKOJJn8z/XyyIgJTyjZ+QmRBroE9kqTflaEN3p6L8+XGU9E7+GmsgA6nCOSGkyCx6mOllYvdj62Ql/jC/5/VbRUrXK9qZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgMopSjinU9hdsxBVqFmsoZ7uZks6jD68b9bm9USWio=;
 b=mthdpcUerzQvPNr0igR6ZXmyZ07FoXfUDhMjIyl8G0OK6X2cvNHUKcdZei0ryx87ON72HG066clPOXVY6J1WxR0El7IjW2qPd2jTahbu8YUkVycNFD3FLBQtJtoC2AZ9HEhb7UEKjVAPyO4ino1mPjm3pB7plLRR3UBYTxAQW2HMxLZ6H7E/n6YA5f6xSGNcWOWemayToChx2oARJMEI18IPi5QXb/3XaTyLo06FIACKzDbLFrEv2tToug5+NB6G2/WQPAozKRVH2ZyI8WemNpGZSUTZxVMtlvp7IgbOseR/FGnFwvGicKpTLAVTb4VyK/v1kdQCLlDxjl/YKjKvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgMopSjinU9hdsxBVqFmsoZ7uZks6jD68b9bm9USWio=;
 b=eruwY1639naPh0M1a/5Rywohd1wmzrGPAk7tUF5/x0sTyYxmdsDK4g+aLwHZa1eyyFfbZDvyXCRla8uTEQWQlDqd1lbetnlug0KM7POPl+CmJw77fne9AHIT8w0DUyXot/s9NQBdTZs9MMdrl+4bJlMjmHveJEBmy4T3D+lWVx0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH3PR10MB7396.namprd10.prod.outlook.com (2603:10b6:610:144::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 23:07:47 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6954.029; Tue, 7 Nov 2023
 23:07:47 +0000
Message-ID: <19f8de0a-17f7-1a25-f2e9-adbf00ecb035@oracle.com>
Date: Tue, 7 Nov 2023 15:07:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: x86/xen: improve accuracy of Xen timers
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
 <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
 <2bd5d543-08a0-a0f6-0f59-b8724a2d8d75@oracle.com>
 <12e8ade22fe6c1e6bec74e60e8213302a7da635e.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <12e8ade22fe6c1e6bec74e60e8213302a7da635e.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:a03:331::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH3PR10MB7396:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e737371-9bf1-41f4-8fac-08dbdfe65ba4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AaCC4TmS4dC+HAkE9w9hR6VLf7+ECyYU2q4AZWeVe6LqAWZpNJz3Myw5GDT3A4BofvpL2VuJ9yme6X26JZqQe5TqijuZoAyfjCluUgxnsFGww9xK/41J9BXib9iQoBK6I2Y+UBQsGt1+KCyggh6n/x1e4SFDI82092Gr4d/E1fy6ev+fNQyL/IkvKrW1YMyDAJWMxiHHzlENigA0AZfNeaG3wbgQ8LdQQLZKCsA99uSgd2JZPRressRrJF3y1sXGQSwRDZDTy5qoncqcbGZ9hNaccukMwZEdQcfyc1XwRaE0beSnZgzFb5u+QfjgmUf1Qr7OBPLCsRDiL3DB5ab3M5zKl1g2qNoSZpikG7OnpY6weot/UF2K8UGz9xzRUAMfFs4tK0Jdf03jC8FBdS7MnNCLzt0YuDggw45t4MpNcgNlTgzdocKDRKePJ6sg6YoPL8I/eKxSz4PWl+KmDAN5dOKyNi6OtpjCfnpkHhv57kUIHe4PmfglELkUDV0jJzGDYTPnOeA/jaX/Sa3yw7zTwym9+ZH/+j8GIPJSYmHtXcCbOKqI65geUoulehub3mimZ2LSCEO2nKAMabyRgbyz11kPAjdOtdYK6Mzfc3K8ryax096E5cW+OZgkQMipEIulQi7e0o57xYEGFYpuRno2bw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(346002)(39860400002)(366004)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(31686004)(66556008)(2616005)(6666004)(6486002)(6512007)(53546011)(6506007)(478600001)(2906002)(38100700002)(36756003)(86362001)(31696002)(7416002)(66476007)(54906003)(41300700001)(83380400001)(5660300002)(66946007)(26005)(316002)(44832011)(8676002)(8936002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WFd1R290Ty9OWEZSM1hvTWhURjluNlFBaGRSck5HdzY2bEFxUEFqZFFtajhj?=
 =?utf-8?B?OGpvc1U2NTF6cDgvVHlKNUpiSTkzcXJ1bjJUNGVjaU4vZ3hzdFhNRi90VjNV?=
 =?utf-8?B?dTRTUFQ4cGxlZGxHS2FBNmNKRDNScVhpVHljQVB2UmgyaHR0SktzRnlhL3Bl?=
 =?utf-8?B?KzdGa1pBNkZlbTlvMlZyK2xCd2dTTytrWGNXNHBIVTFEY29ZMDdvUjBIbVBR?=
 =?utf-8?B?U2hLR0lBSG9KWkZJdWVDVmpMQ3c1WmVzMjF1eFV3UW5VT2ZDVDJXMitOMm4y?=
 =?utf-8?B?a2ZxSndSNThNVzhGeUc0THkxS3NwWjU3NkJWV1NMVm9YMWVOd2lnWGp4T0hm?=
 =?utf-8?B?TzRUS0RNZENFQVZJeXgyeFhqSldGSnJRR2FhdldPTWhReTV0bWhPV25oZFl3?=
 =?utf-8?B?UzU1T0RsaHJNbGJ1N0t6YnpCSnJ1V2EyUGRWYmMyemxCazhZNXI0amtiVmRl?=
 =?utf-8?B?b0lFdGlDWkxyZzAxWTI4NStDMHBFVGdURGcyMG9jQlZSeHc2QnJoQ05zMWV1?=
 =?utf-8?B?THhuZ2F0VThUTFlpTExaOUdqOEtxblkwNzVQQmlGY0w1bXA3b01mRG9XNm1w?=
 =?utf-8?B?djdvSmx5SmFjRVlXQjhmSm9lL21MN2JQVWdsRlI2aUxlL05EYXdZVjl2b29K?=
 =?utf-8?B?RHZuVGt2aW1oVm11dXptYzJMMkE4cWZGZVcvUDV1M3ZsVXpKekZmUGlLU3NT?=
 =?utf-8?B?emkwUituaVA4akZDQUE0dTZsSk9JZ2N6UytMdGFNS0ErdHJDZU5LZVRJRldv?=
 =?utf-8?B?ZlpMM3dLbTBpcjViYlVwSWtncGtCbEpvS3lrT0VjRHFQNlVBVENqR3lPUDBI?=
 =?utf-8?B?bnNtQ1p6Ri90cmYzeTUzeTdKUEJabS82UE1HVi9Ed1doTFpQMEVJS1ZUWTB3?=
 =?utf-8?B?UmZramtHMnYwMmV3cEd1VStHMlB6YU8reWozQzVPWDcyQ3FPUGNncVhzNmxK?=
 =?utf-8?B?NVJPU0ZDayt6TSttaXE0MVhrWXhJeUp0TC9CUmNTV29aWEdncEtMejZONHZw?=
 =?utf-8?B?bFJVa1dlbFdUZCs5T1Vrakt4OFFjVWFWMSt4S1hjQTNIMFI4MWZlQzFEZjdo?=
 =?utf-8?B?RVZmcm1od3JQRlpUTXBiTVJuUEVheUllTlQrTFhQd2dqTkM1U0JDY1RmRTlo?=
 =?utf-8?B?cVdkWDRiUUc4TWFPaW5VZGtCSm5pNHltTzJjQi9CSUcyUUMvTHdTTTk3b1Qr?=
 =?utf-8?B?T0VUM0dIOS9aUSticWlRbWxlK3hncFV6KzJLMGtTNmtQVDMybFdmYVkxdDRl?=
 =?utf-8?B?am1oTkVpWFYyd015OFNFUUkyaENEcU8rU0pHYUE4V1pyZm5aMDFkYVVicXJZ?=
 =?utf-8?B?cmEyMW1YenNnVC9nZkszZXBRUXVtOGhUWW15cFdrMFF5cHZsMlRtazZnSjhz?=
 =?utf-8?B?S3cyck8vVFQ0TEloT0VJVExsdXRJOC9EeUswczFVTkI1bnlXTGtRTnBsOUtk?=
 =?utf-8?B?VDZjTU8yUVZzMHZQbkpNZkRheEdnS0wwUUUzNVl0ZG1QNWZCc2VIWE9CS0Fh?=
 =?utf-8?B?WkoxU21OSWU0cUFaK2libUxlSFhtNGdjdCtsZXBtaXIrTWdKRXAwUTR0dFds?=
 =?utf-8?B?WFc4YlduRjlOTlJxTWJVOVNIUVJJZHhLVm5XN0ZTUkFQcU1vU2JSQ3ZXcmhy?=
 =?utf-8?B?NmpLUTlKMG9VbTRsTEVGUkM5NmVUTDFPZ0JGMlk4NmxSK0NYODRhd0RYTW1x?=
 =?utf-8?B?WERxQlhqZTFjampkYkFId2x6NER4NDg1OU00S0tPZ2lYZUY4R1h6SkJYNUpj?=
 =?utf-8?B?MC9tam9ZeTNBMmJzUGZYbzVaQ0pBekl5MjVMUGlQWGVmclVZRnc0ODhDRURW?=
 =?utf-8?B?dm5tOUpXZHJLS1dLYlFHb2svR3pWdUFBM0ZtUW1vMWdMWjhNK3FaL3NtSUpr?=
 =?utf-8?B?dDZ1T2tQNWkvM25tR0FxaTR3WG9TM3dDMEZ4QnFaUVBaOERuWXZUajRYTUlj?=
 =?utf-8?B?M0VUWldheG0vVHhVdnNwQUZHejB6T2g0WlFvL2w5VmlHek5YT0ZKUm9jbHhu?=
 =?utf-8?B?V01CY1JFMklCSXE1a3FxQXVmRnZsNkt6VnE0Q1IyVHI2aGQ1aEIwWFJaVnVX?=
 =?utf-8?B?SU9ieWtwalZETE1pTm5GbVIydVNQSEFSZHJzM1YzU05GMGFhbHZvMGpzUEYr?=
 =?utf-8?Q?zOaeDcmT5hrWNLfL0AQMY341j?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?SzZNRk85TFdwamNVemladmR0Y0M1OVFzNUE2bjhDVTc5TmF2NkgycUJLWnR3?=
 =?utf-8?B?STE4Mys5SmN0MEdwbXlVd2hzZllQMGJFckFKcWVwSW5hY1BEaUIyUTlGQTRU?=
 =?utf-8?B?VXBlSzZ4cEUyN0crWTdvNFIxMlRsTFFVSzFSbEZTMkZhZkhrUFFzWlRCUDdH?=
 =?utf-8?B?Tkl0djlROGFjV1hWTDdBYW9Rd3NleVN6Wmx5WjQxYlM4T3RueGdjWDM0WWxi?=
 =?utf-8?B?cDYwTk10QWNXUkhxajNaRWw4TkpKVTBHWjNFcDA1VHhLTDFZdHplTCs5ams3?=
 =?utf-8?B?SFJXcGxOMHlIVVBZSUZxVnAxQXRXdHBtYlNrUU0vN2JjZmZYRGs0RlQ2OWlr?=
 =?utf-8?B?TTc3TjJZcUduNFdISG4yQ0pkUXlxcjdVL0dxMUZ5NmlWSk5rWlh5c3JWSDMw?=
 =?utf-8?B?TUFzWVhDOEgwZkZOdllQcjZucFFDR3IvakJEbUVGbGhOTE5peEw2TThWUjVL?=
 =?utf-8?B?Z05Qb210ZG5PY0pQdEpiSTNjZmRUREN5aEtsL3d2WW9sRERNTGNkeVIya2RM?=
 =?utf-8?B?YitwQW56YjBrYmJQSzBwN0dicDZaRUNYaUN2aHVhVlhXQjVUUWZZdUVQREE3?=
 =?utf-8?B?VnN0UGpiNmd1VlFoTkdRckFWYjY3V1pMbllCb1pNYmZ5dGtSSkE1ZUd6YzdS?=
 =?utf-8?B?d0RlYmhIdDVtbWxtK3dXWTlOTUdIQkZ5c2d6a2loRFVGWG9Rayt2RkJtSDcv?=
 =?utf-8?B?RjBzdVA5Qm9waDhwM2dxK3F3M1JMVHZCSHNUSWprOUF4akVETXZ5anNyWU9h?=
 =?utf-8?B?NXRsT0M2bndScXkxNWYwZ0JESVptM2I2TTVPWWFMN1hLc3BaR3YrUHhzc2lC?=
 =?utf-8?B?NW43d20rMFdReDJuWmNCemtlTndLRThCM3RxejduUzZlLzEzcGdRbjF0aDBJ?=
 =?utf-8?B?Z1FsblF2R2o0L0N0dDM3cnVQWGxxc3RvUk1sS0tpMU9kWnVpZEZveDlwQytG?=
 =?utf-8?B?UWVpNHNZVDFITldLemRZZFVQZ3JVdVBCNmdiaTd0MlJBUDhMYzh4SW1vQ3VR?=
 =?utf-8?B?Q0xKd1E0NWY5SEMwTVVpRUlsTytFS1IwMkhncmpBcG94R3ZDeS94LzZ5Zm9F?=
 =?utf-8?B?ais1MHBqZnUvaGNSbEJtNHMycCtvd3dEeHhXTVEyQzZPYTQ3cVFmeWZ2bzZH?=
 =?utf-8?B?U3RieVoranptcWVWQWdxOHB0WFRTaWtuMjhtbGRlaEtKMWExSTczUU92V3N2?=
 =?utf-8?B?QkFmcnpEcTlJaTNxYm45UXh2dnhLR3BSY3hKb09CWDU4dDI0OTJtb1Q2cnBC?=
 =?utf-8?B?MHpxcS9oc3pNQ3MxT2U3UFdVcDBBRkU2TGJFekRndEZQVWJabjdxaC9xNG9V?=
 =?utf-8?B?OUd3ZmIyUDdmaUZQdzYxZ01jS3BBdktZMGVRaWdyN0JDNE55d3hybmtJRXgx?=
 =?utf-8?Q?VHAyS+Gq/eDeYmm3GD8nbNngNMSjBcK8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e737371-9bf1-41f4-8fac-08dbdfe65ba4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 23:07:47.7541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWReLU5/oFIW3Tsb877ZXNVbPPWEqp+/2lkBx7hprtILyBRD3M2yMQIzgWk71mIJY3dyBbOTX8GABHijg5j87A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_13,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311070189
X-Proofpoint-GUID: yQ1U8bJknIzm7VGLO3aV5_Bxzab7RbBS
X-Proofpoint-ORIG-GUID: yQ1U8bJknIzm7VGLO3aV5_Bxzab7RbBS

Hi David,

On 11/7/23 00:17, David Woodhouse wrote:
> On Mon, 2023-11-06 at 17:44 -0800, Dongli Zhang wrote:
>>> +       if (vcpu->arch.hv_clock.version && vcpu->kvm->arch.use_master_clock &&
>>> +           static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>>
>> If there any reason to use both vcpu->kvm->arch.use_master_clock and
>> X86_FEATURE_CONSTANT_TSC?
> 
> Er, paranoia? I'll recheck.
> 
>> I think even __get_kvmclock() would not require both cases at the same time?
>>
>>  3071         if (ka->use_master_clock &&
>>  3072             (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz))) {
>>
> 
> But it does. That requires ka->use_master_clock (line 3071) AND that we
> know the current CPU's TSC frequency (line 3072).
> 
> My code insists on the CONSTANT_TSC form of "knowing the current CPU's
> TSC frequency" because even with a get_cpu(), it's not clear the guest
> *was* running on this vCPU when it did its calculations. So I don't
> want to go anywhere near the !CONSTANT_TSC case; it can use the
> fallback.
> 
> 
>>> +       } else {
>>> +               /*
>>> +                * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
>>> +                *
>>> +                * Also if the guest PV clock hasn't been set up yet, as is
>>> +                * likely to be the case during migration when the vCPU has
>>> +                * not been run yet. It would be possible to calculate the
>>> +                * scaling factors properly in that case but there's not much
>>> +                * point in doing so. The get_kvmclock_ns() drift accumulates
>>> +                * over time, so it's OK to use it at startup. Besides, on
>>> +                * migration there's going to be a little bit of skew in the
>>> +                * precise moment at which timers fire anyway. Often they'll
>>> +                * be in the "past" by the time the VM is running again after
>>> +                * migration.
>>> +                */
>>> +               guest_now = get_kvmclock_ns(vcpu->kvm);
>>> +               kernel_now = ktime_get();
>>
>> 1. Can I assume the issue is still there if we fall into the "else" case? That
>> is, the increasing inaccuracy as the VM has been up for longer and longer time?
>>
>> If that is the case, which may be better?
>>
>> (1) get_kvmclock_ns(), or
>> (2) always get_kvmclock_base_ns() + ka->kvmclock_offset, when pvclock is not
>> enabled, regardless whether master clock is used. At least, the inaccurary is
>> not going to increase over guest time?
> 
> No, those are both wrong, and drifting further away over time. They are
> each *differently* wrong, which is why periodically clamping (1) to (2)
> is also broken, as previously discussed. I know you've got a patch to
> do that clamping more *often* which would slightly reduce the pain
> because the kvmclock wouldn't jump backwards so *far* each time... but
> it's still wrong to do so at all (in either direction).
> 
>>
>> 2. I see 3 scenarios here:
>>
>> (1) vcpu->arch.hv_clock.version and master clock is used.
>>
>> In this case, the bugfix looks good.
>>
>> (2) The master clock is used. However, pv clock is not enabled.
>>
>> In this case, the bug is not resolved? ... even the master clock is used.
> 
> Under Xen the PV clock is always enabled. It's in the vcpu_info
> structure which is required for any kind of event channel setup.
> 
>>
>> (3) The master clock is not used.
>>
>> We fall into get_kvmclock_base_ns() + ka->kvmclock_offset. The behavior is not
>> changed. This looks good.
>>
>>
>> Just from my own point: as this patch involves relatively complex changes, I
>> would suggest resolve the issue, but not use a temporary solution :)
>>
> 
> This is the conversation I had with Paul on Tuesday, when he wanted me
> to fix up this "(3) / behaviour is not changed" case. And yes, I argued
> that we *don't* want a temporary solution for this case. Because yes:
> 
>> (I see you mentioned that you will be back with get_kvmclock_ns())
> 
> We need to fix get_kvmclock_ns() anyway. The systemic drift *and* the
> fact that we periodically clamp it to a different clock and make it
> jump. I was working on the former and have something half-done but was
> preempted by the realisation that the QEMU soft freeze is today, and I
> needed to flush my QEMU patch queue.
> 
> But even once we fix get_kvmclock_ns(), *this* patch stands. Because it
> *also* addresses the "now" problem, where we get the time by one clock
> ... and then some time passes ... and we get the time by another clock,
> and subtract one from the other as if they were the *same* time.
> 
> Using kvm_get_monotonic_and_clockread() gives us a single TSC read
> corresponding to the CLOCK_MONOTONIC time, from which we can calculate
> the kvmclock time. We just *happen* to calculate it correctly here,
> unlike anywhere else in KVM.
> 
>> Based on your bug fix, I see the below cases:
>>
>> If master clock is not used:
>>     get_kvmclock_base_ns() + ka->kvmclock_offset
>>
>> If master clock is used:
>>     If pvclock is enabled:
>>         use the &vcpu->arch.hv_clock to get current guest time
>>     Else
>>         create a temporary hv_clock, based on masterclock.
> 
> I don't want to do that last 'else' clause yet, because that feels like
> a temporary workaround. It should be enough to call get_kvmclock_ns(),
> once we fix it.
> 
> 
> 

Thank you very much for the detailed explanation.

I agree it is important to resolve the "now" problem. I guess the KVM lapic
deadline timer has the "now" problem as well.


I just notice my question missed a key prerequisite:

Would you mind helping explain the time domain of the "oneshot.timeout_abs_ns"?

While it is the absolute nanosecond value at the VM side, on which time domain
it is based?

1. Is oneshot.timeout_abs_ns based on the xen pvclock (freq=NSEC_PER_SEC)?

2. Is oneshot.timeout_abs_ns based on tsc from VM side?

3. Is oneshot.timeout_abs_ns based on monotonic/raw clock at VM side?

4. Or it is based on wallclock?

I think the OS does not have a concept of nanoseconds. It is derived from a
clocksource.



If it is based on pvclock, is it based on the pvclock from a specific vCPU, as
both pvclock and timer are per-vCPU.


E.g., according to the KVM lapic deadline timer, all values are based on (1) the
tsc value, (2)on the current vCPU.


1949 static void start_sw_tscdeadline(struct kvm_lapic *apic)
1950 {
1951         struct kvm_timer *ktimer = &apic->lapic_timer;
1952         u64 guest_tsc, tscdeadline = ktimer->tscdeadline;
1953         u64 ns = 0;
1954         ktime_t expire;
1955         struct kvm_vcpu *vcpu = apic->vcpu;
1956         unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
1957         unsigned long flags;
1958         ktime_t now;
1959
1960         if (unlikely(!tscdeadline || !this_tsc_khz))
1961                 return;
1962
1963         local_irq_save(flags);
1964
1965         now = ktime_get();
1966         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
1967
1968         ns = (tscdeadline - guest_tsc) * 1000000ULL;
1969         do_div(ns, this_tsc_khz);


Sorry if I make the question very confusing. The core question is: where and
from which clocksource the abs nanosecond value is from? What will happen if the
Xen VM uses HPET as clocksource, while xen timer as clock event?

Regardless the clocksource, KVM VM may always use current vCPU's tsc in the
lapic deadline timer.

Thank you very much!

Dongli Zhang

