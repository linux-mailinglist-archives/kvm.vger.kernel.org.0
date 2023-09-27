Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368E87AF7B0
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 03:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjI0B10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 21:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbjI0BZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 21:25:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C22D58;
        Tue, 26 Sep 2023 17:30:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38QLTHJx011001;
        Wed, 27 Sep 2023 00:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DFNa6LL45hLzOJkanxzLqXAaO34OeAfAZqEUWuVUd7M=;
 b=I7HrfI9MzEutcqsB+DxMl7IkNogoSYD8T1cHurTOSX/p1Fo2Hn8XkYHHzhPIhbMLVsia
 ehi4u8q3CihijIULy6xOHqzbNWYnEN2+StJ8Pdma6KpLu6GR9vM/pVAEPuHjahP8VyOA
 KBGI5HnYfupGS0WdsJB7OiFJzdCaLzsN797y/y2WLexeTd3u/gUkMQlIjGVTBOQY9/Oj
 SwYyppsO553sbB2zKJLIVgwh161lNnGQQJawQb/CBwgeGB/bQp/6JjcKzPZT/uBTf+U1
 nCeH91iGaOVYGBxY2PwY2/u/aBJN1Fn/54IW71FdgafzZa1aFLz3sjnwLAb69zg4JhbV wA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9rjug5kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 00:30:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38QN9dcQ039353;
        Wed, 27 Sep 2023 00:30:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfd38vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 00:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9bNKWvGbpiH8JnaW46VBI0GczxaWu/TapB1pe9on/rFDmI7NwdvJk2PCo4pRrTvKGpoNupl+2hBfvJX3zEi1oDvFvDioHoIZZylvtYYukCeaifF3E2aTnAzg3oKEYeG1s73nYB58OoZIij75SFXbP18jkuhw3CEoyrHdpXq0Sxl8LSSUDFcFYZdvY9wQEZSbwd/9/19GDFkVM7h4WQzZ56l5JPAXMxl/JW+kvnIigsGMQsi4RzllvdxFE0YIojHreUxcvt4wfcsl7HJ6QEij0FvOWJymN1Ga1v7dTo9xgJ3PTJbdbyXRWtBNyKYJKXYBfUaX4TniGWZkmuW1RgPGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFNa6LL45hLzOJkanxzLqXAaO34OeAfAZqEUWuVUd7M=;
 b=UhNyYkPrJhlfpZiFp3vEJP+3BlIRk7ifbnH2XHPDhAKmPG2F2+xL66wEHuxQq/fbv4pprxK+1eHpDYErIGbyy2P9bnOBk5TPjqirAE5c/DRIxUu8pJ9pothXEIcXF8yyAdDEIm6dXy0GaLHX+DfykZmvaXxmSOtrwNcfUJ6jaEZxNrq5goTRQhmFuQIf/CagBRaFuqMuE89pXlSxDlB+M9j9P4wAGDmqbT1Yl01Z1wykm8Ek/NSnE6d9p5VX8owNr0b1xWkAimkmpOQDhtM3xQDOuFD5vHJOaKpA55wnzeYJGBbPE1sb7ywkmHZrfmcAQIVd1qkmfpGpmW+EjA+88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFNa6LL45hLzOJkanxzLqXAaO34OeAfAZqEUWuVUd7M=;
 b=RsLrhCvN18Po96Vj4E0NpHdxnrP8d5NQu5lKeprXR92MVlVPLBxc8GK9DAqurES2pBWVJi5g0OSuJWlRTU3DTs08DZhzJ6Yg39v+0Ev4smv3IZdeWUIm1TDyu9DuRsBZDfjnnVtaHvQOxOtz24HpRfmqPtWuON0c0eHb+C4w2bE=
Received: from BYAPR10MB3160.namprd10.prod.outlook.com (2603:10b6:a03:151::20)
 by CH3PR10MB6884.namprd10.prod.outlook.com (2603:10b6:610:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.23; Wed, 27 Sep
 2023 00:29:57 +0000
Received: from BYAPR10MB3160.namprd10.prod.outlook.com
 ([fe80::276d:1b5a:b89a:54fb]) by BYAPR10MB3160.namprd10.prod.outlook.com
 ([fe80::276d:1b5a:b89a:54fb%4]) with mapi id 15.20.6813.027; Wed, 27 Sep 2023
 00:29:57 +0000
Message-ID: <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
Date:   Tue, 26 Sep 2023 17:29:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
From:   Joe Jin <joe.jin@oracle.com>
In-Reply-To: <20230926230649.67852-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::20) To BYAPR10MB3160.namprd10.prod.outlook.com
 (2603:10b6:a03:151::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3160:EE_|CH3PR10MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 185ae3b8-5f83-474b-7639-08dbbef0e089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sz1XQK/3JEj0r2RLp552PSgBLWr4ADFGT85urFhwl1cShKU+Q1zhmgWSwkelnVEudHBR5m2Pr2GV7LQyfexgmVlyowwH5UzEn2PSbzfoy4YRg4O7xPc0SpgoU80QdakQ1Zd+BBvHgNQKVuy9M495kumHXfXbhsIOL5Cpy0XmBd/fPhE/Gk5GwDTvATXdDWEesopduX0IPhtntQd9HDIblcql7eSIbKbsnjufXvGOJa1sYKsWRdOiAAE1Nz/W6HTxDxz8JxNn90yRiSus2a97GpRQBzk9EQ6LuDHvfs8bu85TdaHeu6qfeF8f2jVAPWqEBLv8Th5MF8C7X8uQwb3U2NY0a1CjJLCVzLx1AXuWiQrILC4Bj+4e62VZAGMHUdkz5clXA2cHTUOJGwmDtFc6Pbh6ynt7/cUa2DcQ3GnFCLhIC8mNHMXr8xlraLdE7lG+pPHCvkVAUF9WOYuvF3wO5H02+KIP05arkbcmVtW6Fl2tBtaeM36d+hCEBXPE1fxw8NBUcK0N9z/NI1ofCgdXvOWM/4YQXoQC1zrkEi2lr0SQt9Omo36DbB4sSxirP/vbPbd10vJNvw4PUmOVPvw6yLsu5PK7nFRx0xfS6T7yjRIfN9rIIv0ZqpSuE/rwplSdcNe0jltIwZcomzEctslTTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3160.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(136003)(366004)(396003)(230922051799003)(186009)(1800799009)(451199024)(2616005)(66899024)(26005)(38100700002)(36756003)(31696002)(83380400001)(86362001)(41300700001)(5660300002)(66556008)(316002)(44832011)(4326008)(8936002)(66476007)(2906002)(66946007)(31686004)(15650500001)(53546011)(6506007)(478600001)(8676002)(6486002)(6666004)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmxPN3VMcVZDTEE3cW5vL280eVhWRGxaZysvZzlYVGlMc3Z2UDNBdkszWSsw?=
 =?utf-8?B?RStDMm5nSllkRkFHWFZmS1hxa2RKYW1MMGx3QlArckYrNmJFMVUraUZEWnhF?=
 =?utf-8?B?YUpDQ3E3aW5pczZXVXZvNkFDRzY3SFR4UWpkbjhScjZqamh6RU96RzBCdG0y?=
 =?utf-8?B?VkhlT3pRY0Z4REIyM2o1ektibzZyZTc1eG9nZDNuUVRxR25hTHlseWVnalZM?=
 =?utf-8?B?bjVyZnZGYTd2SDUvOVVUc1FkYXgxbHUyemlKaGp1K013VldFMkdZWmMydmVn?=
 =?utf-8?B?S1JlWlBPdUc5Vk03V3pXaE9DcWRLclB2NnFTbGZzYkpQVVZqb2k3cU5hM2dU?=
 =?utf-8?B?Ym55OGlvUnpzZVV2VGRtdXpZb1hycnJJdGYwZ2NYS01jSmlRZ3RqRW1Ya04w?=
 =?utf-8?B?dVVld21JMFpjb1NxeE10SW10VnhSMDVsNWp1NDMvUzN2M0dwR1ppZEVWTmJW?=
 =?utf-8?B?d0tzc29sZGo0QkxEVzBnY2dpcDFQMG1kbnc5RDV0K2krOEtSdDRMZm9OYTN5?=
 =?utf-8?B?NWJuYU1EelUyNlVoZWNUNTYyMmp4ODMvY0VGdVFRSEFPZDZVUHZCUWV6QWhL?=
 =?utf-8?B?UVI5dWJJOStKZW5FVVp4b0tlZGJGNEZydzJaTWhKM09rRmluQ1ExbFVQWFF4?=
 =?utf-8?B?VnZxbjdPbjZhUWFlU242N3VlUjEwMGoyS2Z1dkJmcmRDbURybGJwZUg2TnVU?=
 =?utf-8?B?elB4T2V4dy9ZdFh5azFDRktheHljcTN1ZzV1Tk5iQTdYV3pveXZwdTg1UkUv?=
 =?utf-8?B?b1lETFpNQ20vbWM2V3JHdXJDMnh2ekJQbmdobnpmL0psOE1LS1BmLytpejUy?=
 =?utf-8?B?TlJIbjZXRGdKTDJCbWpLOXJ1YnVqUGV5UnUzQi9iNWpsVmtPbHdSUDVkM0xw?=
 =?utf-8?B?Ym1CMDVQSGd4MjRYTDZQVzEzZTk3K3NpZTI4RWloR0lXVEFnWU80OVFDbG1T?=
 =?utf-8?B?WGdVbG9wa2w0a0NYN21XcUsxcnVoL2xJZEtMVUdNb2w1bGdJY0xHUkovMC9a?=
 =?utf-8?B?Ukhyb0s5Z3BQeVNXRFczRXVkK21vbzdhNnp6OFBEbnd0RUFYdnhqTVIvOVlS?=
 =?utf-8?B?aXFOY0wrQVJDLzc2MUFiVXM1cFlKS1lQRFdNMWVLVWJ2dzBQL25wT1F0Z29J?=
 =?utf-8?B?Z2JsTThJQ3NhVGZwTlNXUjFXMFlJOVA5QlJCWGlESTU5Mi82Yy9mN2xkeTF0?=
 =?utf-8?B?dmwwSm9WWlZFYXhRTXYwSHNLRkVOajJDTWpvekNvSUNIYkc4V0dNZEtwc0tP?=
 =?utf-8?B?WFcxM29OTmhmSmR3QVdIeHQydVo3N0VjdU9vNk9rQ2d4SVpRNlRvL2JJRFRR?=
 =?utf-8?B?dll4WFRMNUI0aWg2NHowaVp0MTN3S1hGdVY5b0V3d0ZhQWJKTDZlSm8vR3M5?=
 =?utf-8?B?alY5VWlRNy84M1RjYVcza1FHQmh6R3RKWjRWQU5IQ0p2OUtNZlJnaEt3M2cw?=
 =?utf-8?B?RVhZVkdwNTdLNWNOVCtCYXFTUXcyTk1KbnZ5RW1VMk5YNUg5Z0hnWGkvajRk?=
 =?utf-8?B?Q09BSk9jMHU4MThlcFE1WW5PRytNNCtEZkV6M3ZlbVUvalRYYUd5MEtLcnFP?=
 =?utf-8?B?bXBwSDN4U29aSFU2alpzTGlFWDV1VXVSZFBEVXlDVEltSXNQemxnUG5iTmR4?=
 =?utf-8?B?WXpUa2NWUXZXMVRIRzJIYlpyT0Z3MnNLQU02QXpESnlXSDNqMFZqbmU0am13?=
 =?utf-8?B?MFBXajc1SDhvSkVaMXZrdkdmTTYrcXB3eDZhSXZCRlFraWJNbWl3akRMM3Ni?=
 =?utf-8?B?MElST0owbU1VajhVT2lFZVVHdGZ2WXIxcHU2aHd5bkhyM2VnWGxaTitaalhv?=
 =?utf-8?B?ejR4N3Q4eWN1Q084am5iZFB4dEszbk1XMk1oY2ZwT0QySTlaN1ZrejRBOFcv?=
 =?utf-8?B?eDlDZ3lrZHRBQnNoR0VqcWFzaHBnT09JR0ZZM0hZMWd2djdRY0grcld4blBM?=
 =?utf-8?B?N1lXNFZFQ0tFNTFpZnJVMUN2UzJEcXNaM0xHTnV3RWN6MmxWZ1F3UFdUb3Zh?=
 =?utf-8?B?MzNXMUN2Z0pWdTBwQ3hwTHltUmt0cjNleGdJeDJnRVVFRUhweVJIRU9pbkRM?=
 =?utf-8?B?M3EzYjl0RjdQZzg5NEx2dWg0ZDFja2VVK3pjVzIyRVFtcnc2K0UxZ0VNRElT?=
 =?utf-8?Q?k9/2kZ3RVII4deAWc+WGJjc66?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NHJaOVE0WVRycnpLek41a3V1R2Z1UkxxU0d3MzZaYVoyMWZmdnVkcU1EY1NQ?=
 =?utf-8?B?dkdBSDRxd2tqV3ovRDl2N05wQWdIYmlWVzVLRHdvOFljYnhiVFFwSU9QQWlj?=
 =?utf-8?B?Um9uSTVUajZQV0xDRFBIQVdQTXQ1MkU2VzNmMUt0dzRPNkJCLzRsWTl0ajR6?=
 =?utf-8?B?QXlkc0czZG5vRXdhMjZQM2l3SDEzZ2VlLzF0S0EwUnVpeDBzZmJ4bkMzSFo5?=
 =?utf-8?B?TFh0OVJjQnp3Tk9wQTVhZDVnR3UvTVBtbUJjTXVjaE10NW5PN1czQnlnaWZF?=
 =?utf-8?B?NXAzQ2k1a01WeTBRMFcyZjVuNU9CK1hVNUFXVkZrdHg2MEFLekVHaVhUSU5z?=
 =?utf-8?B?cEppZXZJOGM4L3I0eTdjNEZKUi9UN0ZKcjBJRmVxZERzMXZZYkVSSWxWL1lH?=
 =?utf-8?B?S2RidWF3c2dPRDNOb1RJVjI2Y3dlcDBFWFVTNG5TaFdpMHpsQ1h4RHdibHNJ?=
 =?utf-8?B?OGExQjRuUmpnUWg5LzZNT1gyYmJiQ1h5d0czS1dCU1ViSDRKeHFNdzBSbXR0?=
 =?utf-8?B?dnB6UXF0a3k4dEpadldYcDQrWGNDMFlHcXRyVjFuek9VdEtDcGlBT2hHeTc3?=
 =?utf-8?B?MUhEVFpUS1FFaFlndTkyeHd6U2I1SWd3amJ0YUpqc3RKVHBuWjExdFVMa3RK?=
 =?utf-8?B?TjcxeXZIREhjZmIrUmdtTlZyckZVbW5oRTdES2k3ZmpDUFFlR2Vpc3BES1Iy?=
 =?utf-8?B?bkhHdHBDbHAycHBDVVZrOE5sZ3h2a0ozVzJrZWhNRFVDL1Y5c1U1VXpJUVhN?=
 =?utf-8?B?VC9wVFpWRVJ2RU9DcW5GNzJQY1JsRk1QNEc0NjJhZjZONU9rZnZlSDJKTTU1?=
 =?utf-8?B?WkJWVXgrYVNhcDg5R1J2TFFTU0FMRlhkaUtpaVZueG1saG56UXRtOFhLUk91?=
 =?utf-8?B?ZjkwdzF0MVdqdW9vclB1dkQ0RVBwM1VJT0dnd296Tk1xS21XUHQrT1dvVUs5?=
 =?utf-8?B?OXJtMTNGRFVPVEcyTmNKbU5PS0FFcDNlUzNObXdRb0JNeHdlL2k0V2N3VUF2?=
 =?utf-8?B?cCtYOWhPY2FXaHlNd1pDR3YvTmNGcFhYVEgySU9JRlhwSGhVQVJkTXllZnBN?=
 =?utf-8?B?SnJ1S2I3M0x0VkRkOVpXQXIxSkkvVGswVHVUQk5vU0RUZ21wLzZZZjZYc3Fo?=
 =?utf-8?B?VG5BVVZ3QnBOQjY3aDFpbnlHbFpLaUwxWUpuSjdmeWhPMktHRTRxN3d3WmNC?=
 =?utf-8?B?eGlrWHMvUzRuNFI2R3VlQUQ2MDhhYytVeGRZNjJhc1o5Vyt1OEw4NkJqSTBS?=
 =?utf-8?B?SVNJVlpXVDZGbFd6OWhDbU0wTExON0FrTzRIWmR5UFZyTUwwQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185ae3b8-5f83-474b-7639-08dbbef0e089
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3160.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 00:29:57.3641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECErfG1luPi02XMZabSDWLYL4g5UBSaCClKzS0IhxS6PcgNv4xPaq/7qF5Fr1mpmyWdiQq/RZAjB5lKiX5fs9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6884
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-26_18,2023-09-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309270002
X-Proofpoint-ORIG-GUID: 1nFTM8y-__nuDMfai_5CG0NAM5i3ap_K
X-Proofpoint-GUID: 1nFTM8y-__nuDMfai_5CG0NAM5i3ap_K
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/23 4:06 PM, Dongli Zhang wrote:
> This is to minimize the kvmclock drift during CPU hotplug (or when the
> master clock and pvclock_vcpu_time_info are updated). The drift is
> because kvmclock and raw monotonic (tsc) use different
> equation/mult/shift to calculate that how many nanoseconds (given the tsc
> as input) has passed.
>
> The calculation of the kvmclock is based on the pvclock_vcpu_time_info
> provided by the host side.
>
> struct pvclock_vcpu_time_info {
> 	u32   version;
> 	u32   pad0;
> 	u64   tsc_timestamp;     --> by host raw monotonic
> 	u64   system_time;       --> by host raw monotonic
> 	u32   tsc_to_system_mul; --> by host KVM
> 	s8    tsc_shift;         --> by host KVM
> 	u8    flags;
> 	u8    pad[2];
> } __attribute__((__packed__));
>
> To calculate the current guest kvmclock:
>
> 1. Obtain the tsc = rdtsc() of guest.
>
> 2. If shift < 0:
>     tmp = tsc >> tsc_shift
>    if shift > 0:
>     tmp = tsc << tsc_shift
>
> 3. The kvmclock value will be: (tmp * tsc_to_system_mul) >> 32
>
> Therefore, the current kvmclock will be either:
>
> (rdtsc() >> tsc_shift) * tsc_to_system_mul >> 32
>
> ... or ...
>
> (rdtsc() << tsc_shift) * tsc_to_system_mul >> 32
>
> The 'tsc_to_system_mul' and 'tsc_shift' are calculated by the host KVM.
>
> When the master clock is actively used, the 'tsc_timestamp' and
> 'system_time' are derived from the host raw monotonic time, which is
> calculated based on the 'mult' and 'shift' of clocksource_tsc:
>
> elapsed_time = (tsc * mult) >> shift
>
> Since kvmclock and raw monotonic (clocksource_tsc) use different
> equation/mult/shift to convert the tsc to nanosecond, there may be clock
> drift issue during CPU hotplug (when the master clock is updated).
>
> 1. The guest boots and all vcpus have the same 'pvclock_vcpu_time_info'
> (suppose the master clock is used).
>
> 2. Since the master clock is never updated, the periodic kvmclock_sync_work
> does not update the values in 'pvclock_vcpu_time_info'.
>
> 3. Suppose a very long period has passed (e.g., 30-day).
>
> 4. The user adds another vcpu. Both master clock and
> 'pvclock_vcpu_time_info' are updated, based on the raw monotonic.
>
> (Ideally, we expect the update is based on 'tsc_to_system_mul' and
> 'tsc_shift' from kvmclock).
>
>
> Because kvmclock and raw monotonic (clocksource_tsc) use different
> equation/mult/shift to convert the tsc to nanosecond, there will be drift
> between:
>
> (1) kvmclock based on current rdtsc and old 'pvclock_vcpu_time_info'
> (2) kvmclock based on current rdtsc and new 'pvclock_vcpu_time_info'
>
> According to the test, there is a drift of 4502145ns between (1) and (2)
> after about 40 hours. The longer the time, the large the drift.
>
> This is to add a module param to allow the user to configure for how often
> to refresh the master clock, in order to reduce the kvmclock drift based on
> user requirement (e.g., every 5-min to every day). The more often that the
> master clock is refreshed, the smaller the kvmclock drift during the vcpu
> hotplug.
>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Other options are to update the masterclock in:
> - kvmclock_sync_work, or
> - pvclock_gtod_notify()
>
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 34 +++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 17715cb8731d..57409dce5d73 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1331,6 +1331,7 @@ struct kvm_arch {
>  	u64 master_cycle_now;
>  	struct delayed_work kvmclock_update_work;
>  	struct delayed_work kvmclock_sync_work;
> +	struct delayed_work masterclock_sync_work;
>  
>  	struct kvm_xen_hvm_config xen_hvm_config;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f18b06bbda6..0b71dc3785eb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
>  static bool __read_mostly kvmclock_periodic_sync = true;
>  module_param(kvmclock_periodic_sync, bool, S_IRUGO);
>  
> +unsigned int __read_mostly masterclock_sync_period;
> +module_param(masterclock_sync_period, uint, 0444);

Can the mode be 0644 and allow it be changed at runtime?

Thanks,
Joe
> +
>  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
>  static u32 __read_mostly tsc_tolerance_ppm = 250;
>  module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
> @@ -3298,6 +3301,31 @@ static void kvmclock_sync_fn(struct work_struct *work)
>  					KVMCLOCK_SYNC_PERIOD);
>  }
>  
> +static void masterclock_sync_fn(struct work_struct *work)
> +{
> +	unsigned long i;
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
> +					   masterclock_sync_work);
> +	struct kvm *kvm = container_of(ka, struct kvm, arch);
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!masterclock_sync_period)
> +		return;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		/*
> +		 * It is not required to kick the vcpu because it is not
> +		 * expected to update the master clock immediately.
> +		 */
> +		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> +	}
> +
> +	schedule_delayed_work(&ka->masterclock_sync_work,
> +			      masterclock_sync_period * HZ);
> +}
> +
> +
>  /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
>  static bool is_mci_control_msr(u32 msr)
>  {
> @@ -11970,6 +11998,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
>  		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
>  						KVMCLOCK_SYNC_PERIOD);
> +
> +	if (masterclock_sync_period && vcpu->vcpu_idx == 0)
> +		schedule_delayed_work(&kvm->arch.masterclock_sync_work,
> +				      masterclock_sync_period * HZ);
>  }
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> @@ -12344,6 +12376,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
> +	INIT_DELAYED_WORK(&kvm->arch.masterclock_sync_work, masterclock_sync_fn);
>  
>  	kvm_apicv_init(kvm);
>  	kvm_hv_init_vm(kvm);
> @@ -12383,6 +12416,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
>  
>  void kvm_arch_sync_events(struct kvm *kvm)
>  {
> +	cancel_delayed_work_sync(&kvm->arch.masterclock_sync_work);
>  	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
>  	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
>  	kvm_free_pit(kvm);

