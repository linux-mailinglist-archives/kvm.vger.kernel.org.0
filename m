Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159067D054C
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346703AbjJSXMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346670AbjJSXMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:12:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F93106;
        Thu, 19 Oct 2023 16:12:27 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JKuM29011378;
        Thu, 19 Oct 2023 23:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=YyLWm7+ksttNZT9eGXTE7n93fg0u9xw05R9EmbVYJqc=;
 b=3h9sBocv2OQ/MOlD35cX0vbMTcfL4dDvHgD+pDqlyNDQJ4RJOlOQ2MPm9q4UTUBZF5x3
 +sODgZVluAV2EwibIQ1U78hPO+wHmBhFFU2Qlw+egd2hDeB9U8P/aVEQKzaevo8xmHvU
 fMeG2IqzZcgCJv7K+lPU58YfD/1ZKJxKQ3rq+IdthMNQa+uFYjcsbjscwa4G2TqF7Hb5
 ivxoRSSV0x/IMY8UrUeTKxc5KLHK939Ras3Axx64PDUA0Bc1bZZd5sdAX5yId7eSP1t2
 lPAOY01PFRE7m0X5bwlVTZ/j7i/4pkqILgb+m6IF8OmQ7qa7qtoQzmBlttaupMi2bZrM sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubw805fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 23:11:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JKrjPw038476;
        Thu, 19 Oct 2023 23:11:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw442cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 23:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dx8XvH/CtWgQ7cYSpRY9SMMR/OPgMgFP/Up0uCtZb4IWP2DiGZPmR7MoVgqVsf2GPjQM+Sc0+rUBSnigBDMTQ6cE2896P/YLMNv+gL41ayZHKdfj2V+seqYf7FVE8AahHUNPzfhXUQrpapfxMxVHtiQhY4mAlvACizWxPFJIGmTTyfEtEVn8rzJMxcjfn6zy+3ug0R9yvFlc+U1gI0TOwtvD5a8erYXQweRkNc1iJEmqsuBrhtgKGsakj3mIO68iGg/kwjTjzvRs2C/lx3WHHr6CgeFrinWBP1qLLI6mgoSR6+jBLfyyp9F0ubnjhWiGS7u94YlzYcVc6zOfJWFgVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyLWm7+ksttNZT9eGXTE7n93fg0u9xw05R9EmbVYJqc=;
 b=dJ4yVotII5jeJAqph8aaWZsCXUERoGLOizpxcuIHolBovuXMtSdfQEKJX1veWQQ4uj3h3GRENncAqWw7Shv32d5vp21TeYOpMZ1XzPYOGu1PbjBcL0TZt77KObbgf7QdprszTAlDco6aYlvGJV0Zg+8cOYclD/OsZ/QgAtB2HluANDd87XxTH1exygdZk/H/hyYTj3RYy55jgVks2ZSL9wmSxX6mdfqahIjksB6L49EHXBIWrMx+yCR2pcgmHsM8B8sugIrQ3KsiD1Qe+8R/otPNrH/3IbbjJZEcmFboY7AW46EChl48lSHv1rTkFn4s9BQPSg4wX/e1YE8b9pbBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyLWm7+ksttNZT9eGXTE7n93fg0u9xw05R9EmbVYJqc=;
 b=o5tcbcgybRJFflfL1HW7bbK7SFEQ5xAJdCQgUod94kVjOVS9Zr23gUPDSgKn/HHamIahfExnBTR8TPcGtB0dS3hmasSX0C2enWMhGCR4khLa4ExpKJRC689Ab2E2eV/L9JK6yGPj5ZmEz/lPs4z3+SXBDpH5cSA1h2v86lDAwus=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH7PR10MB6227.namprd10.prod.outlook.com (2603:10b6:510:1f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Thu, 19 Oct
 2023 23:11:16 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 23:11:16 +0000
Message-ID: <06e0a926-d6ad-8266-6571-583292365eea@oracle.com>
Date:   Thu, 19 Oct 2023 16:11:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] x86/paravirt: introduce param to disable pv
 sched_clock
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, dwmw2@infradead.org
Cc:     x86@kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, pv-drivers@vmware.com,
        xen-devel@lists.xenproject.org, linux-hyperv@vger.kernel.org,
        jgross@suse.com, akaher@vmware.com, amakhalov@vmware.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, peterz@infradead.org, joe.jin@oracle.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
References: <20231018221123.136403-1-dongli.zhang@oracle.com>
 <87ttqm6d3f.fsf@redhat.com> <ZTFOCqMCuSiH8VEt@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZTFOCqMCuSiH8VEt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0155.namprd04.prod.outlook.com
 (2603:10b6:806:125::10) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH7PR10MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ef3f3d-7b06-458f-f09b-08dbd0f8b262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sRoPlkI9sDJ+B+diJdJvw8SbWdofSMvL3N0DeJOacHd4KCxNChGLjG8eAQpCLgLuBMavFUfY86MzyTtuOtL1Gcqpn3Gg2wWeHER1aI8gDCcNkjtqIOKP0zBWGtyss9ocoghRmXfOvpT9rr6H8271MQCRh0pwwIM0TwiDTGRbVkJs+/0ekAUgQmYCFOFh6FfqmPWraUtNd4O3B9kPIhh7FRBbMaoz3+sZj+BEDxC97nn35NfOK3Wary56LSqbVFi2+SFl5Oi3u70uRDpI4MtatWiBjGZLH4dTU7GauP4AP5pJG+y2njAImV7YZcF1m+yEKhHrN0zcrVZlUpF+uhMOAvhcmZqb6IEPNkeHFQx+g3ye2EL9vNS5m+RZtJN/D1ULMuc7n9dSwSwygbKqeJGY97+61q7KlPVtS9PyeOyZigervhYaDTyFi+xxgyNfJ30/yuTOJAbCXkOfOqCo9myB9fj+U1RY/7MguT5SQKpNrO81DaAfgjVG8/UCYn1NDdvXH6/DssXXbTlWK5msaDoKx1B1BTXlu82I+NnF2jCuCQ7ZIgEp3q+fJqvGv8Y98Q63bjBQOY1OG6Sag3M4Y1guJmV3QBN/Z3TGm4e9zh8+OfubgxjdMPVi3r0m70GOE+AJ7YtrJPJJ2iRB/fQE1ZyyKQLRahZPai2ydm56u32j1KC7rKZfxspTiLthY2baQHpc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(346002)(136003)(366004)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(53546011)(6512007)(26005)(83380400001)(6506007)(31686004)(2616005)(6666004)(966005)(8676002)(6486002)(4326008)(316002)(41300700001)(5660300002)(31696002)(30864003)(38100700002)(36756003)(8936002)(2906002)(86362001)(44832011)(478600001)(110136005)(7416002)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFAxNGN4NEc1SlRuUXdUNkdKVWpnbnhwNTl5VnI3emcvQk5kaVliazVuTTFs?=
 =?utf-8?B?SWUzb05zSGVJZmRjRXFPN1Rpc25lNGJsZFVUdFQ5OE55aTRjNC9TT08rOWQ4?=
 =?utf-8?B?R25pZk9QT2NUby93ck5RTS8rbTVBWEIra1V4SUdaVXV2UVloZmpFSThkbTIv?=
 =?utf-8?B?K3MrUW9CRVNPUTRhaTg1RmdqTHRJOHUwOThyeHhCSHlBOFBnb1lMZnNwWjZH?=
 =?utf-8?B?bXR5UmJSM3c2cUx5blFMUVFXcUE0QkVWY3ZrZU9zSFRjRXpMeUc3eFl3Z3dZ?=
 =?utf-8?B?WEh3UjByakhFZDB0MU5rNHRodWo4YTNsMFZ2aUhwUlhFL0lUNVN2QzYySXA1?=
 =?utf-8?B?Y0JUVG1lNytrUUVTYlZ5N0t0QkQrOW5HZENtOVdsczN2ODNzM3NPeEJDdit4?=
 =?utf-8?B?UVRiNTIzRmJMYzR6RHRPSmYyb2FVWktwY3ZnWmpMOEx5NXFOQkF6TVdPMExH?=
 =?utf-8?B?aHQ1bGQ0bGlMMVhtb2t1SCtrdFQra3dHcGhhU3BEK1VjZ3JBNHpteXBCbHBx?=
 =?utf-8?B?Q1FmZXE2b1o1M0J0WXFYZFVkZ2ZMTW9SMTFwL0srUUJRaDhWQTRMUkx0WThX?=
 =?utf-8?B?V0FCQXEzeTdKcXQ3WTJIVGdORUQzSktPcVVGK1FIQU1udGx5WnRDM2ZvSEV4?=
 =?utf-8?B?T1E5bVhYNlpzSVhnU3VNK3J6cFQyaWxiVHgvWTROU1hiempCVWhybE1FQ0dj?=
 =?utf-8?B?NGJCOHpmREh6c2V1cHJyaGhnZDM4Tk9HVkk2Q2ZpVDQ4b01Hb3NjRTh5VGd2?=
 =?utf-8?B?QzNCQTdnSVZiSndXOFRKVFlHWHIrYUxsVXN5M0dtVzF6c0Z5MnZTZlE3SzMr?=
 =?utf-8?B?QXlrbnMyTzFMUnE0OUZWNlJRTlVaYmUrSjF0a3NqNWRFY3ZaS2NsRDhHMlZy?=
 =?utf-8?B?MEpwcTdoMmZ4cm5GZ3JZRmtHSXpSK1B3VmRIa0JtRlFRd0NkbkJ5bnIvbzRa?=
 =?utf-8?B?YjJQZmpJTGVvT2kveUpGd2psU2lOVzVRc1hlZS9TdXliN2sya2Uzd1cvM0pa?=
 =?utf-8?B?c0luaUtTYmhUZDY1OVM3KzhVNmo1K2IyZ1RiMmRiQThkWGgzVmtUS05EdEZi?=
 =?utf-8?B?UnpoUGxTckZYSnN1QlpoeWRSdFY2Sk9UaHBXbGhhTkRvNGFacG5SM0FhYzNr?=
 =?utf-8?B?Tng1N2lneWtEVU5VWFJLSjcrbHR0dEUzNU1OMTJRQTBkN2lnRGFwdWhKV1ZY?=
 =?utf-8?B?N1ZSVE1NZEdIY1ZNR3UxTkkrZlVkUnU0elRnaGMvZ0ZwNGg2SjloeGVkVHNC?=
 =?utf-8?B?a3NvWFNrY1pmUHE5bVcwVzkrcGNXa3d4UThKc0pQNytQZXU3UHFSMktiZGNY?=
 =?utf-8?B?UWE4clZyOUY1YmZFQkRmK0dpTFNlZU5JWXdaZDgxUUsxZFN2Y2JPbFNMUTNn?=
 =?utf-8?B?ek9KbU5IR3J6RDV6T2xaT285WjRCVUx1QU5LdGRBZElyTmxNQS9GbGRqWFZ1?=
 =?utf-8?B?eFM0eDVLZ2cydXpLZWdIQW9QclZIYzRpSlRZTTUvcmdXV2gwQWZUZGtMRyts?=
 =?utf-8?B?Ny96UnY3TCtLaXVvQXRXcElSWFJpMXNqYU1xVVh1Qlo4NHpnRlNXUU9tZWFk?=
 =?utf-8?B?SFRhT0VGandvOXRqSjFKeUdZaEo0SmZLb2p1enBobGVObk5lVlJJZzZTNlhw?=
 =?utf-8?B?TFBDb2NPVmRkTUVhSXFvZHBoZVB1QUNoMUZaY2ZaYmhlRzBzUEV3Y2dnSFNr?=
 =?utf-8?B?UkFEQk5nRFRzdEg3SEd3cFNOZWQ1VkZvUG9USWVsVkYydHpRU2duMHhwRUtM?=
 =?utf-8?B?bzVreDJaUjZGTnZRR0tiMFpmMmxCdVR4eHhPTXJwUjBMakRMNWN0bDhUMTFF?=
 =?utf-8?B?eitqM0VVT1lnRHhDN3lEejJvUEJkQ0M3NjZuRjRKN0xkUW5uaXhMYWF6S1dX?=
 =?utf-8?B?Zmw3RHBVV0p6dmtVWGFnTGQxOFBnZG4vK256bGgxbTlwMCsxSGZYZnNyNTdO?=
 =?utf-8?B?VE5zSlo2dVRuMkhSQXUyNUxQcUkrWU5oSnQvdlRpYjZ2NTA2SXM1ZW0rOFhu?=
 =?utf-8?B?RXVvbUg1MWpwck1mTHVmT0JiaWtnbTR0S2J6bjBVa0hHTG5icjM4VzJaNWpG?=
 =?utf-8?B?Tm1Rc1dNVEplRmM3b2t4eWIyVEhlcUYvVUdjZWNSb2wxMFdyZ1hscHEybDFH?=
 =?utf-8?Q?epjmqEDlhuVwzVejutfr+Ml6T?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OFVBWVJDeVk5WTYrWjRaMVZxY1FaN0hDajNlWjVWSC8vOXZGV0hqWm5iSHdW?=
 =?utf-8?B?RzdUckd0a3pOWEk5ZU5qdUR3WXZkc0xDZmFOUXVkUFNyVGhNM2xBclZQS1Mv?=
 =?utf-8?B?QmY5TnQram1OdGZVbk41cEhaaHlmNmdxWER6UFVpeHgzQ0dlZlFBY2hhWGdE?=
 =?utf-8?B?WVI1cHhYcHZKSmtLZDl3NTNjZGI0NVQ4cFJGQlJTbm03QjNQZnEwaCtPdWhp?=
 =?utf-8?B?ZzdOcS9KVFFqcWlobUlyYnJlN1ozWHZKc1FDbkNsdnR4aUcxVmRNNFZPajdh?=
 =?utf-8?B?ejRQUExqY2R2VEVvUjdnRnZrc1hDNnRaVWxFRkNRbVcreGJTbEpHRm5Ea01E?=
 =?utf-8?B?N0JiWWsrMmZ1RmxMT1QrUWtiZnZQT2R6Z0NLb0doVEpveUZkOUJIYml3eWxY?=
 =?utf-8?B?aWxmQlVBQ0ZXbms3Vm9iRHhGczRvMXBhREJaelowTzlZcVpCWEZFdmo1ajZY?=
 =?utf-8?B?OXFSSDBYNTIvV01BbWxQUWNzK3cvVDc5dzRPRFgxeGJnTFUzeEdmK0NScStz?=
 =?utf-8?B?WU1ETG1iakJoMXZOaG5ZZlRVaDBsQXk3ckFlVTUyMWlwbExJQXF6NWlrS1lR?=
 =?utf-8?B?bmZZc0JNZDczTnJrNzNnd1VsMDBJeE5udERkUUFBK3l1akEzZ0lWNytQSm9T?=
 =?utf-8?B?WDUwZm0wRnpRMHl4ZVVPVFVsdEpiQUFBeHU1WndyTDZTNUlucEh6NzIwa1dm?=
 =?utf-8?B?bDNpQ2Ntdk5jeDJHWW1jZjNxS0VmNnNhMFU3MytRQjJxd0hrQytqejJ1MWxF?=
 =?utf-8?B?c2FQek04YmJIUFRWelVHUitwM3JzbHpkMGZDdVRLSUZpUnMvTFVtb1NOZzdF?=
 =?utf-8?B?YmVDc05oUnZvSXkrTGR1ZXJhR0hjYXduYWI0WEdDOHlvTm1TZjJNZ3NOeDRV?=
 =?utf-8?B?bTRJZEdUdnNlQ3ZDQkIrZnpRTnZQZU1iSFMvKzJ2NmFmR2plMEc5WXpDZUxG?=
 =?utf-8?B?VVB1RVRBZUQvYm9RakNqYllUYVFyVnhlbTRrR00zbHdIaUFvWGNhSkpDbW9H?=
 =?utf-8?B?YUs4WlpnRUUvWmNxV2JZVUNtVzkwVEZIY2VQMGMxVmppU05kRER5QTBROVpq?=
 =?utf-8?B?bHZMUlZKcVNjMU9ZSFpxSDdiemROUVYyb2hHOVhwR1QyVzlyMnpJZUNkTm12?=
 =?utf-8?B?dEFuS3hKd1UwNkNpbjVScmd6NEFHUTNPZHIzOXRqOGF4bktCMzczdy82eVFH?=
 =?utf-8?B?U3NHVTZ2emxOS2ZLZ1ZMMGF2M2V3MWhVN01QZWUzVWVIZWRIa295dVNWL1E4?=
 =?utf-8?B?NENSWXhoNFp3d1dCWmVOOHc4byswVjM5b01PcStaa2dkaTJrUy84amRNUnBy?=
 =?utf-8?B?OW95alpnSEZrNGhLMml0SEFoUEtoN1NKWk5QM3JyS1A4TllCNVBxQVpicERO?=
 =?utf-8?B?ZTRzQTNNUEJTem84UWNKc3F1THN1N2k5cHRnWWNqQUlyUlRYUmI3L3VCY0VP?=
 =?utf-8?B?dEtGTnErRHJ1Wk1ZMWx3VnExdXc3emI3dENlUWxRME5mZjNOS1dnS09rNlhh?=
 =?utf-8?B?eGhESUkvS1JocDNmemxIVWhsTlVXbjE4T3RCV0dBTmNEZnVuR1NacEZUbmVC?=
 =?utf-8?B?NnVPRzVNYjN3ODliM1FPRFBDYTZMYzFQTEloeXVXRXJwSWt4N0pnVEZRNyti?=
 =?utf-8?Q?UWfUQsxJRX9QwbkAifkZUHFjKs1MiZVqyv8DqNHKmiCA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ef3f3d-7b06-458f-f09b-08dbd0f8b262
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 23:11:16.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rf4mqG4yu5PMPgABze0N2o/rbEu73PeUhrxQ7Tf7K3FVofd0EDWpgYjXGCMLBO7Kulnp6/MKBbvfMX23drSNDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_21,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310190196
X-Proofpoint-GUID: hjhkdoqT-Mz3-hmy0gVYF3kfu7GxJ53W
X-Proofpoint-ORIG-GUID: hjhkdoqT-Mz3-hmy0gVYF3kfu7GxJ53W
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly, Sean and David,

On 10/19/23 08:40, Sean Christopherson wrote:
> On Thu, Oct 19, 2023, Vitaly Kuznetsov wrote:
>> Dongli Zhang <dongli.zhang@oracle.com> writes:
>>
>>> As mentioned in the linux kernel development document, "sched_clock() is
>>> used for scheduling and timestamping". While there is a default native
>>> implementation, many paravirtualizations have their own implementations.
>>>
>>> About KVM, it uses kvm_sched_clock_read() and there is no way to only
>>> disable KVM's sched_clock. The "no-kvmclock" may disable all
>>> paravirtualized kvmclock features.
> 
> ...
> 
>>> Please suggest and comment if other options are better:
>>>
>>> 1. Global param (this RFC patch).
>>>
>>> 2. The kvmclock specific param (e.g., "no-vmw-sched-clock" in vmware).
>>>
>>> Indeed I like the 2nd method.
>>>
>>> 3. Enforce native sched_clock only when TSC is invariant (hyper-v method).
>>>
>>> 4. Remove and cleanup pv sched_clock, and always use pv_sched_clock() for
>>> all (suggested by Peter Zijlstra in [3]). Some paravirtualizations may
>>> want to keep the pv sched_clock.
>>
>> Normally, it should be up to the hypervisor to tell the guest which
>> clock to use, i.e. if TSC is reliable or not. Let me put my question
>> this way: if TSC on the particular host is good for everything, why
>> does the hypervisor advertises 'kvmclock' to its guests?
> 
> I suspect there are two reasons.
> 
>   1. As is likely the case in our fleet, no one revisited the set of advertised
>      PV features when defining the VM shapes for a new generation of hardware, or
>      whoever did the reviews wasn't aware that advertising kvmclock is actually
>      suboptimal.  All the PV clock stuff in KVM is quite labyrinthian, so it's
>      not hard to imagine it getting overlooked.
> 
>   2. Legacy VMs.  If VMs have been running with a PV clock for years, forcing
>      them to switch to a new clocksource is high-risk, low-reward.
> 
>> If for some 'historical reasons' we can't revoke features we can always
>> introduce a new PV feature bit saying that TSC is preferred.
>>
>> 1) Global param doesn't sound like a good idea to me: chances are that
>> people will be setting it on their guest images to workaround problems
>> on one hypervisor (or, rather, on one public cloud which is too lazy to
>> fix their hypervisor) while simultaneously creating problems on another.
>>
>> 2) KVM specific parameter can work, but as KVM's sched_clock is the same
>> as kvmclock, I'm not convinced it actually makes sense to separate the
>> two. Like if sched_clock is known to be bad but TSC is good, why do we
>> need to use PV clock at all? Having a parameter for debugging purposes
>> may be OK though...
>>
>> 3) This is Hyper-V specific, you can see that it uses a dedicated PV bit
>> (HV_ACCESS_TSC_INVARIANT) and not the architectural
>> CPUID.80000007H:EDX[8]. I'm not sure we can blindly trust the later on
>> all hypervisors.
>>
>> 4) Personally, I'm not sure that relying on 'TSC is crap' detection is
>> 100% reliable. I can imagine cases when we can't detect that fact that
>> while synchronized across CPUs and not going backwards, it is, for
>> example, ticking with an unstable frequency and PV sched clock is
>> supposed to give the right correction (all of them are rdtsc() based
>> anyways, aren't they?).
> 
> Yeah, practically speaking, the only thing adding a knob to turn off using PV
> clocks for sched_clock will accomplish is creating an even bigger matrix of
> combinations that can cause problems, e.g. where guests end up using kvmclock
> timekeeping but not scheduling.
> 
> The explanation above and the links below fail to capture _the_ key point:
> Linux-as-a-guest already prioritizes the TSC over paravirt clocks as the clocksource
> when the TSC is constant and nonstop (first spliced blob below).
> 
> What I suggested is that if the TSC is chosen over a PV clock as the clocksource,
> then we have the kernel also override the sched_clock selection (second spliced
> blob below).
> 
> That doesn't require the guest admin to opt-in, and doesn't create even more
> combinations to support.  It also provides for a smoother transition for when
> customers inevitably end up creating VMs on hosts that don't advertise kvmclock
> (or any PV clock).

I would prefer to always leave the option to allow the guest admin to change the
decision, especially for diagnostic/workaround reason (although the kvmclock is
always buggy when tsc is buggy).


As a summary of discussion:

1. Vitaly Kuznetsov prefers global param, e.g., for the easy deployment of the
same guest image on different hypervisors.

2. Sean Christopherson prefers an automatic change of sched_clock when
clocksource is or not TSC.


However, the clocksource and TSC are different concepts.

1. The clocksource is an arch global concept. That is, all archs (e.g., x86,
arm, mips) share the same implementation to register/select clocksource. In
additon, something like HPET does not have sched_clock.

2. Some architecture has its own sched_clock implementation. E.g., x86 has its
own sched_clock implementation in arch/x86/kernel/tsc.c.

309 notrace u64 sched_clock(void)
310 {
311         u64 now;
312         preempt_disable_notrace();
313         now = sched_clock_noinstr();
314         preempt_enable_notrace();
315         return now;
316 }

3. When !CONFIG_PARAVIRT, it is native_sched_clock().

4. When CONFIG_PARAVIRT, it is sched_clock_noinstr()->paravirt_sched_clock()
referring to paravirt specific implementation (native/kvm/xen/vmware/hyperv).

That is, the pv sched_clock is a concept under x86 when CONFIG_PARAVIRT==true.


Although the implementation is possible, I just do not like the idea to change
some arch global code, to accommodate some requirement as a leaf of the tree.


How about to keep the change at x86 as in below? It won't work unless I change
'tsc_clocksource_reliable' to an early_param.

---
 arch/x86/include/asm/paravirt.h |  2 +-
 arch/x86/kernel/kvmclock.c      | 12 +++++++-----
 arch/x86/kernel/paravirt.c      | 16 +++++++++++++++-
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6c8ff12..118b793 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -24,7 +24,7 @@
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
 DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);

-void paravirt_set_sched_clock(u64 (*func)(void));
+bool paravirt_set_sched_clock(u64 (*func)(void));

 static __always_inline u64 paravirt_sched_clock(void)
 {
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f5214..0b8bf56 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -93,13 +93,15 @@ static noinstr u64 kvm_sched_clock_read(void)

 static inline void kvm_sched_clock_init(bool stable)
 {
-	if (!stable)
-		clear_sched_clock_stable();
 	kvm_sched_clock_offset = kvm_clock_read();
-	paravirt_set_sched_clock(kvm_sched_clock_read);

-	pr_info("kvm-clock: using sched offset of %llu cycles",
-		kvm_sched_clock_offset);
+	if (!paravirt_set_sched_clock(kvm_sched_clock_read)) {
+		if (!stable)
+			clear_sched_clock_stable();
+
+		pr_info("kvm-clock: using sched offset of %llu cycles",
+			kvm_sched_clock_offset);
+	}

 	BUILD_BUG_ON(sizeof(kvm_sched_clock_offset) >
 		sizeof(((struct pvclock_vcpu_time_info *)NULL)->system_time));
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 97f1436..f8ad521 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -118,9 +118,23 @@ static u64 native_steal_clock(int cpu)
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);

-void paravirt_set_sched_clock(u64 (*func)(void))
+bool paravirt_set_sched_clock(u64 (*func)(void))
 {
+	if (tsc_clocksource_reliable)
+		goto refuse;
+
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+	    !check_tsc_unstable())
+		goto refuse;
+
 	static_call_update(pv_sched_clock, func);
+
+	return 0;
+
+refuse:
+	pr_info("sched_clock: use native when TSC is reliable");
+	return -EPERM;
 }

 /* These are in entry.S */



Indeed my favorite is to keep within kvmclock.
(This won't work until I turn 'tsc_clocksource_reliable' into early_param).

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f5214..f16655d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -286,6 +286,7 @@ static int kvmclock_setup_percpu(unsigned int cpu)

 void __init kvmclock_init(void)
 {
+       bool prefer_tsc;
        u8 flags;

        if (!kvm_para_available() || !kvmclock)
@@ -313,19 +314,8 @@ void __init kvmclock_init(void)
        if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
                pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);

-       flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-       kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
-
-       x86_platform.calibrate_tsc = kvm_get_tsc_khz;
-       x86_platform.calibrate_cpu = kvm_get_tsc_khz;
-       x86_platform.get_wallclock = kvm_get_wallclock;
-       x86_platform.set_wallclock = kvm_set_wallclock;
-#ifdef CONFIG_X86_LOCAL_APIC
-       x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
-#endif
-       x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
-       x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-       kvm_get_preset_lpj();
+       if (tsc_clocksource_reliable)
+               prefer_tsc = true;

        /*
         * X86_FEATURE_NONSTOP_TSC is TSC runs at constant rate
@@ -334,10 +324,31 @@ void __init kvmclock_init(void)
         * Invariant TSC exposed by host means kvmclock is not necessary:
         * can use TSC as clocksource.
         *
+        * The TSC is used also when tsc_clocksource_reliable is configured
+        * in kernel command line on purpose.
         */
        if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
            boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
            !check_tsc_unstable())
+               prefer_tsc = true;
+
+       if (!prefer_tsc) {
+               flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+               kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+       }
+
+       x86_platform.calibrate_tsc = kvm_get_tsc_khz;
+       x86_platform.calibrate_cpu = kvm_get_tsc_khz;
+       x86_platform.get_wallclock = kvm_get_wallclock;
+       x86_platform.set_wallclock = kvm_set_wallclock;
+#ifdef CONFIG_X86_LOCAL_APIC
+       x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
+#endif
+       x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
+       x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
+       kvm_get_preset_lpj();
+
+       if (prefer_tsc)
                kvm_clock.rating = 299;

        clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);


Thank you very much!

Dongli Zhang

> 
>>> To introduce a param may be easier to backport to old kernel version.
>>>
>>> References:
>>> [1] https://urldefense.com/v3/__https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Omk8Q6d8PW-UcKNdCRAeA8qSb698y3Eier2hro5vporwTCHqHSmYYk8fCinciVOHUG40CK4GQpHsjNlDiQ$ 
>>> [2] https://urldefense.com/v3/__https://lore.kernel.org/all/20231018195638.1898375-1-seanjc@google.com/__;!!ACWV5N9M2RV99hQ!Omk8Q6d8PW-UcKNdCRAeA8qSb698y3Eier2hro5vporwTCHqHSmYYk8fCinciVOHUG40CK4GQpHh5avzQg$ 
>>> [3] https://urldefense.com/v3/__https://lore.kernel.org/all/20231002211651.GA3774@noisy.programming.kicks-ass.net/__;!!ACWV5N9M2RV99hQ!Omk8Q6d8PW-UcKNdCRAeA8qSb698y3Eier2hro5vporwTCHqHSmYYk8fCinciVOHUG40CK4GQpH74It6kQ$ 
> 
> On Mon, Oct 2, 2023 at 11:18 AM Sean Christopherson <seanjc@google.com> wrote:
>>> Do we need to update the documentation to always suggest TSC when it is
>>> constant, as I believe many users still prefer pv clock than tsc?
>>>
>>> Thanks to tsc ratio scaling, the live migration will not impact tsc.
>>>
>>> >From the source code, the rating of kvm-clock is still higher than tsc.
>>>
>>> BTW., how about to decrease the rating if guest detects constant tsc?
>>>
>>> 166 struct clocksource kvm_clock = {
>>> 167         .name   = "kvm-clock",
>>> 168         .read   = kvm_clock_get_cycles,
>>> 169         .rating = 400,
>>> 170         .mask   = CLOCKSOURCE_MASK(64),
>>> 171         .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
>>> 172         .enable = kvm_cs_enable,
>>> 173 };
>>>
>>> 1196 static struct clocksource clocksource_tsc = {
>>> 1197         .name                   = "tsc",
>>> 1198         .rating                 = 300,
>>> 1199         .read                   = read_tsc,
>>
>> That's already done in kvmclock_init().
>>
>>         if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>>             boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
>>             !check_tsc_unstable())
>>                 kvm_clock.rating = 299;
>>
>> See also: https://urldefense.com/v3/__https://lore.kernel.org/all/ZOjF2DMBgW*2FzVvL3@google.com__;JQ!!ACWV5N9M2RV99hQ!Omk8Q6d8PW-UcKNdCRAeA8qSb698y3Eier2hro5vporwTCHqHSmYYk8fCinciVOHUG40CK4GQpFjD9PZNg$ 
>>
>>> 2. The sched_clock.
>>>
>>> The scheduling is impacted if there is big drift.
>>
>> ...
>>
>>> Unfortunately, the "no-kvmclock" kernel parameter disables all pv clock
>>> operations (not only sched_clock), e.g., after line 300.
>>
>> ...
>>
>>> Should I introduce a new param to disable no-kvm-sched-clock only, or to
>>> introduce a new param to allow the selection of sched_clock?
>>
>> I don't think we want a KVM-specific knob, because every flavor of paravirt guest
>> would need to do the same thing.  And unless there's a good reason to use a
>> paravirt clock, this really shouldn't be something the guest admin needs to opt
>> into using.
> 
> 
> On Mon, Oct 2, 2023 at 2:06 PM Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> On Mon, Oct 02, 2023 at 11:18:50AM -0700, Sean Christopherson wrote:
>>> Assuming the desirable thing to do is to use native_sched_clock() in this
>>> scenario, do we need a separate rating system, or can we simply tie the
>>> sched clock selection to the clocksource selection, e.g. override the
>>> paravirt stuff if the TSC clock has higher priority and is chosen?
>>
>> Yeah, I see no point of another rating system. Just force the thing back
>> to native (or don't set it to that other thing).
