Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B095B7CB62E
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 00:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjJPWFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 18:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJPWFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 18:05:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA43A1;
        Mon, 16 Oct 2023 15:05:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO3D4017528;
        Mon, 16 Oct 2023 22:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dHE696cPxODN/lu1/Af0OQq5dfUl4EaERIRN4My2udg=;
 b=uUlaB30Sco06ApNKVNAZKUJmxWZ52UXMYfJ+5F+BucMfg2UleLB2shmEVCygbHcdacHj
 jdQyWJMP9iUoH1pBvE7KHvNZe9CTXDBz4xQaPVUeOEOh960LFC5bGiymdxOgkNcihj+I
 FU6nlVew7hY7LYuCz7vL5z4gwBqfSA8ZgGSxYqGwIlaW6Qem6lgN7Sr4oGtAXVFTR4Zc
 cm3dU23gjda0/EDOetaQ4DRWa0kZ13y2N/85S9p4o8tqTy5e1biFSC4IWquOzOBEvpk3
 w+wXFAzku842WalxM+PAwhBxbU5oRzfKCwQqdmJQA5NLe91BU/zs4LbokfSppMYHGIJS 9g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cutyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 22:05:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GJvKto040665;
        Mon, 16 Oct 2023 22:05:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfykg7bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 22:05:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLxhKX4nXGLbtvtR2jz1l4cPBFWRZqABn3cM8mdSOLIfspJOlPKCvgMQf6G+rsjAYh9ZUBTUnciuh5zAHPRjw/W6LONC3r1OFeacCLs5tCEIi+gvK2Z+1rr5COU5BZVo+EuAPTaQLWJ9/4kpGshgcNz2E7KtXSb1QPSAPyl4xMHZ8Szt6hczl+Yvr2HE47ZbsnE5lHWDPt2XR/mWOZ5j2NLmIE4o/0Mh9nxxWGZGRQcAU9bZOG/jG6UTLMxWfkwskKDnrSO8fpUnFrSFP1no+3quoT6TM7Ri9Sc7jJOwhlppN/c9zmC6K/0lcbybc9/h0CSwFGytvxH43dLoJ6yQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHE696cPxODN/lu1/Af0OQq5dfUl4EaERIRN4My2udg=;
 b=drD9oC81UHZOFH63njymxsog3HxVCD/PPfjZ2Lg5zDfFc7Sj7dE97OBS4e+1LSD5m5MdE3gUQIC8YBM21wfOS9APVcDJq4BHvLFtBo14gYzHLq3MY1hecqXQqx9q5N9oCjjEzyB4lNYJ+uIbwcU9UqU3kPbdeeM8v98a78do4OHHGN9vloOrXnOE+ia7zrgkuKHGJILx9oG4NxfQShyHnCeM0zJ+zr8Sn5q8r64ulpFtvKBTOPHIKKYrp44bfWcQbXv+LiVrzuXOgEGisA5WIlepw5lHb8vx6a0LQfE38pOXavnyo8hRxJCdPkrX7LogiiR1eG00DNDQD2NFFBbZgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHE696cPxODN/lu1/Af0OQq5dfUl4EaERIRN4My2udg=;
 b=GD8pJe6OwkMQhmoIvJ2SJbePOo7o7a3ROEi0bdH77GqF3OLTvFcpgDIjbUNDRm+H4P6u0t09OPMPIplsq1H/phYQxKxSBl8/CT0QLTqOZX6xwQy2ajmwHBb9ufH/F8xeteKS7Q98Y/Th3IcXbDT7lH/kI8KYnYdH8JuI/AXEBSM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MW5PR10MB5807.namprd10.prod.outlook.com (2603:10b6:303:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Mon, 16 Oct
 2023 22:04:59 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%7]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 22:04:59 +0000
Message-ID: <b3721f33-d5b0-79db-8500-d6b93dded0c1@oracle.com>
Date:   Mon, 16 Oct 2023 15:04:55 -0700
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
References: <ZR2pwdZtO3WLCwjj@google.com>
 <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com>
 <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com>
 <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
 <ZSnSNVankCAlHIhI@google.com>
 <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
 <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com>
 <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
 <ZS2Fq5dr2CeZaBok@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZS2Fq5dr2CeZaBok@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:5:334::28) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|MW5PR10MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: ee4e01d2-602d-41e4-74b5-08dbce93f069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRWyWzJZTsHbk9gWfCZjhqRFCox0t62FHYsHHh2gc4iiZlEds84jdQeyi4lXHFZm68f4/WUarKznbCy2vXWHKDvJFfTSIkp0YDC7FJGmof1PV1XjfyOMv3cbArdhs7mEwzU7gtikBxxlZlO767t8gUSiHDTf0koYdIHo9wOWaoW5Zg/v8gR8HRVzDnLeX2a9RHripO23SLyZp/rof0qSxqxD+KL2eMmH7I04Uj7iaDmvRIEG4FooTmmp9cYzor+3W18RJPss3/peFUVO+vQZ+zIUwQJ2LVM4JT8H32Y9EjHfODJEifmBxaVKrise9P+eZd59ITeOff7ZLON65lUTwTdo03aAEexovKa3xcZAK0zzRoaUSB6UzaNlsMbuhYwdJusUuoMdOLKrWg7Mp3HpNihSB5ndrnTMOf484KkvLOWKJdnr6d0KqX+oTn859trKIdUprHpAGF3oWvbHsEPMuNV1E2jia8Md3VUNEuDmb348rOkzrROOxwoCYKHlpi3RaCxbj1XrLV7NRLy3b7r3T0hxVEA3qD7cS7a6+f7czrygnRFTVaH3q4+hfCEf2RPfdSDY9YYwe192va0RSJJYbL0v849hRsO4OF8wbobdqdRieJ3u+pAa4Na3x7HJBipXIzfWbQpPSAKy2rZInNweLn6Ia63Z3QlIPvMy/6k1vBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(31696002)(8676002)(6506007)(316002)(66476007)(66556008)(110136005)(44832011)(66946007)(5660300002)(478600001)(8936002)(36756003)(6486002)(4326008)(15650500001)(7416002)(4001150100001)(38100700002)(6512007)(2616005)(6666004)(26005)(2906002)(53546011)(83380400001)(86362001)(41300700001)(31686004)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wi9seStNUFFKWDNzSXQvQy90TDd6NHJUQ3B4NGU5ZEVCYVF3RzY1dzBRRFRL?=
 =?utf-8?B?UFVmdlZVei9FN1g2MmxqZWhDZ0ZQMlFJcGNJVGxhNGRUcU55ai9vYWFLMkdq?=
 =?utf-8?B?NWs2VlZJclZPRUM3M01qZE8zcXpkLy95QzJhWi96VW5idUxUS1YvR2NxTGp1?=
 =?utf-8?B?T1drSzZuOVdHSDh5M2F0dVFXdmtMVVk5L0wycDBnMW4xb1ErbGhyZjFCUmNt?=
 =?utf-8?B?MlFmQ1liTmhNdVl2RUltWXJiS3dYdjZaRm5EWVQyZnVYTmJBZytOeHcxZnB5?=
 =?utf-8?B?WlI5YVA1Z3VZMEZUSjY5ZlJpZGVVS1JzTDQ3OE1BbTVrdVlmRnlHRkZmY3Fj?=
 =?utf-8?B?K0RQVnFPcjdSN0ZwWlVsZGJkeEtJRzM2dnk5NG0zYWp1Nm9JMC8xV0xTUFBE?=
 =?utf-8?B?cnF2STRSek1EcXBtYkZnSFFwU0o3Q292T0lwZ2ZZWjVxQnpLelVmUVNSUldJ?=
 =?utf-8?B?RnE1a201ZzQ4TVYzb0d5ZVlKVSswN3pSNmgvaWsveWxWSGxzOGdTYU5heEgy?=
 =?utf-8?B?clNYM0l0Qk1ST1ZzTlRjTG9tL0lITzlMZ0xwWGUrYjA1bTBYZXkyVG93d2JG?=
 =?utf-8?B?TWF6ZHgyQmw1ZitwMCtCYWxUV1dXalRBclQwT0NPNTEvWDFPeUhuUkNoWWw3?=
 =?utf-8?B?T1gxdHBpTjhmZDB3U2VReHlxVlNCZnB3NE14NGNsOVMyekhrMUpqc01vVXo4?=
 =?utf-8?B?My9obE8zdkhHWWxxcDRERlRlS29PYzFoQ2JXSTFPRno0VkE0VFhPQmMzMkRH?=
 =?utf-8?B?dGdGYm5hakE3MzUvZkVDUU1yMzFBYk5yNjdYY29VK3Z3a3F2R2lHcVVXTy9T?=
 =?utf-8?B?ZlBLaHNPc2JqWUN1blBHdWdxdDdQUDJ0R1RXNmZ5RlhYc3pDMkJ2MmpBNkNC?=
 =?utf-8?B?eWZsWkJEeWoyRDBURk45eVhzbTV1STJlWjFXSXVNTCs1UWpoV0puVGlnOTFp?=
 =?utf-8?B?WHNXamMxWXlLOCtOVDJod0hMNXdjRzlFVkgrWFFNQ2o1Z2Q3ZUU4UXI4WnVE?=
 =?utf-8?B?QnRvdHh3ejdaRDUwRTEzZ2dBSG10MHppbE9sK1BsZWlGd25mNk5WWng1SE40?=
 =?utf-8?B?RFVUdmFhV3hXdTIyNEdicXpsMElsUkdXZzZaazJqcGhmbUJOWXNWSkEvbVFH?=
 =?utf-8?B?aHNUckVNVmNvQ0ZIck5RdFhpb0hrQ3FGWEJuS3g5NFhFYWkrME1DQm5UMmRB?=
 =?utf-8?B?bXp1ZXdzYTVCVlAzMnBPNlRiS2ZHanl2a1o2bkpFMVRTWWZYWjRteE9KUTlK?=
 =?utf-8?B?Vys3OWhDU3JDOFJBMWhmajhwK25MaVJ1cUFuRTYxZTIyU3B6YThLNmZoZ0Jn?=
 =?utf-8?B?SjJJRHl3NlIrbmxDeGNIMWl5N1lkVmFnYnVIMWgzdTFBQnpVLzNEOFBvNGxQ?=
 =?utf-8?B?bE1KNjJGRWFDZWZ3UXhlQlBPd1VWcVMybjlGS0JrRTczTDRyYlhiSndNWXlu?=
 =?utf-8?B?REViY0pyN2d6RFB3dHJaSmg0THRwYWcrb2RHMU43TzYrSHZrcFlSOHRQc1Rp?=
 =?utf-8?B?RTU3aWZyc3hCeFRSUFE2TUFjR3JqU1JWNlZQckhZZ1lJWFZ0cmxyNzZ1VXpm?=
 =?utf-8?B?QUpUcHlkYWhmb2l1R1NIVnlCdHdjaWhSb2lubVBwU3lwY1FKcEg1ZUxQb2JE?=
 =?utf-8?B?cW9nOFJ5eTgxQ3JoTW9UNUpCblpxbzlGQTVRMUpkNkM1aFVEL0dweS9LY0JT?=
 =?utf-8?B?YnBoeWNEbTZtZ1JVRUtyanJhaFFFWGN4Vnp2OXoxcnhDVlRUdkE3azdSNW5w?=
 =?utf-8?B?eXBvSitrdkVHb2FNR3BoWTNVdUxlb0swdHE5Z3pVTjlNc2lmYTA5ZjVGWFZk?=
 =?utf-8?B?L0lHdVBseXJRODBKSXZURTA4UXp1MGxubjAra05NMExQWGgwbVdKeE50UnhZ?=
 =?utf-8?B?c3Y4dTNQSVkxSU8vVVJmUHpNUmJMcCtoK1dqOGhUZ0IwaDUwaGJ4YzdtV0Uy?=
 =?utf-8?B?aVJwdFlyRHF6Q2xjWEtjZWd1UzUyZTZLelBQZm5wZ1V3aUh1aERPTlNlUjIz?=
 =?utf-8?B?TU9VeExhTThhQnpCTm5XMk41Tk5MS1ZESmRDVEtDTWNCbnF5c0VUZGxzaTJ6?=
 =?utf-8?B?aFlJbUlKOHdLMlNMMktmZ3ByMDk2eVFieDlvNmhaTDB1M1dCOHdSS1A1cGFi?=
 =?utf-8?Q?KioJ/hrLZjjKRFhODKHJtXXNX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Rkp4TmxsSERPWXd4YUVkTVZLUm5KN0phelBOUEZkaEsrTHpOTVh2ZG02dVhr?=
 =?utf-8?B?K0NEM0NRNmhKTkpSMFU2Vys2dlNXK0NvRmozeTJ3OFU0YXYrSzJoK1NDaVl4?=
 =?utf-8?B?d2VEaE5XdG5OZUVCM0lkeWJIUEZQS25Ob2Fxazh2c09MTmZMMUVmWkhPekZ5?=
 =?utf-8?B?THVjVjRyMWw4ZGNQUUM5RXZISGpZWVZ6QkphejNVQ1U5T3RmKzFrdkJsdjEr?=
 =?utf-8?B?NEZ6NlhaVG1yNWxqTWpRZk1uU2JXNEVSdkF1a25yZ0tMT2JtN0t1REtEbmtJ?=
 =?utf-8?B?K0ZRVXVFOEl3YW5GcFFJRjFGUWFXNDIva1NXNDlXaGdGcGxpemtnL3hZc0N5?=
 =?utf-8?B?TExLUlVmei94MWpCWUV1ZlYvaHlvRWRodmladnptK1pNWEJ2L0tDOS90RXRs?=
 =?utf-8?B?NzdtanJnNnFnU2dIdmxhaUVtZW5RZUtyeTNIdTdXSktQNmxvRFE5TDZiVUlo?=
 =?utf-8?B?a0xBWHR1QzJzODE3TEkvVElER3FncGZENFArWXlEY2ZBbkRYNGdRN0pRVTRk?=
 =?utf-8?B?aitrKzVLYk5ZV0tUYk1nR29xTU1DMENhYStmN2NFOHNicHdBam9FL3lXM2tm?=
 =?utf-8?B?NUlrVjBsZmxETmdDeXJlWENoSmw5M2YzMGpMS0c4VUNXYlo5ak9DOEtzMWFu?=
 =?utf-8?B?WDUyMlhET1NoOC83QzFESjJ6YzJwaStFaE04cGYzb09RZ2RSNVNUanFxcHN2?=
 =?utf-8?B?RDhaMExFeVhMVEpjNlJHdlJkNU54bVRvT09rMm5FYVhOSCtxaUdFRGdKV2Zz?=
 =?utf-8?B?MnEybVptZ1JHc2tseDRLRXIrSVVtbE14NmJGbXN6TUloL25CNElVMzBkY0Rv?=
 =?utf-8?B?ME5ZeitIVksvSk1zZVNTZ2VnOXpzSTRRZUgrZWxMbzhIL2ZmODl2ZkxKa2xj?=
 =?utf-8?B?VXErTTVRRllNK3QvUWVwblM4RlN2Z0UrMVNtdktLZ3pBdVFLMFN3Tk9MZ0ZJ?=
 =?utf-8?B?TFFpazZOaTNLeVdybk1kQVhoempyNk1CRFUycmdUZWNUelVYck9KcGNvajdn?=
 =?utf-8?B?NlN0cWY5cVJabytmbis2TEp0OGFtRUU2U3hBTUpVeDJrRTdBV0dIYVZQU3ZN?=
 =?utf-8?B?SlZHd2VSeEd5U3c1TUlmUVZkQVptTENSY21GWnhmT0pxbmdHQlI1L0pUQzFr?=
 =?utf-8?B?RWp3c2dzdElmY2pmV3djYjE4NmNxQXovNWhWaXQ5Y1FkN29HMHI5VG01cHRD?=
 =?utf-8?B?MHE3V0p4MGpWTFRldWFpZk5hTW5zeEpuSjdOUlhHSlZGWVRTRkNhR2RQTmZP?=
 =?utf-8?B?WnpoVzQ2bUViRjQzZTRXTzgxSE9VSllwQTJrejVwQnNxdGxtUXBDQ3Yxc3Jl?=
 =?utf-8?Q?lTsXw+V84Dis/jLOJPfTLgCD1gqU7VGzeo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4e01d2-602d-41e4-74b5-08dbce93f069
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 22:04:59.3819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCYVSbGBxii2XvN2Fcg0bf74u2JkwWXjQNKSGGZ7IlvEgQsp9Ps9ROSN6WXStPyMSQyMdVYaeba5M/RGLUVWhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_11,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310160192
X-Proofpoint-GUID: es_NBnJnkmuLaOgS_W7suYUDRwHGYP55
X-Proofpoint-ORIG-GUID: es_NBnJnkmuLaOgS_W7suYUDRwHGYP55
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/16/23 11:49, Sean Christopherson wrote:
> On Mon, Oct 16, 2023, David Woodhouse wrote:
>> On Mon, 2023-10-16 at 08:47 -0700, Dongli Zhang wrote:
>>> Suppose we are discussing a non-permanenet solution, I would suggest:
>>>
>>> 1. Document something to accept that kvm-clock (or pvclock on KVM, including Xen
>>> on KVM) is not good enough in some cases, e.g., vCPU hotplug.
>>
>> I still don't understand the vCPU hotplug case.
>>
>> In the case where the TSC is actually sane, why would we need to reset
>> the masterclock on vCPU hotplug? 
>>
>> The new vCPU gets its TSC synchronised to the others, and its kvmclock
>> parameters (mul/shift/offset based on the guest TSC) can be *precisely*
>> the same as the other vCPUs too, can't they? Why reset anything?
> 
> Aha!  I think I finally figured out why KVM behaves the way it does.
> 
> The unnecessary masterclock updates effectively came from:
> 
>   commit 7f187922ddf6b67f2999a76dcb71663097b75497
>   Author: Marcelo Tosatti <mtosatti@redhat.com>
>   Date:   Tue Nov 4 21:30:44 2014 -0200
> 
>     KVM: x86: update masterclock values on TSC writes
>     
>     When the guest writes to the TSC, the masterclock TSC copy must be
>     updated as well along with the TSC_OFFSET update, otherwise a negative
>     tsc_timestamp is calculated at kvm_guest_time_update.
>     
>     Once "if (!vcpus_matched && ka->use_master_clock)" is simplified to
>     "if (ka->use_master_clock)", the corresponding "if (!ka->use_master_clock)"
>     becomes redundant, so remove the do_request boolean and collapse
>     everything into a single condition.
> 
> Before that, KVM only re-synced the masterclock if it was enabled or disabled,
> i.e. KVM behaved as we want it to behave.  Note, at the time of the above commit,
> VMX synchronized TSC on *guest* writes to MSR_IA32_TSC:
> 
> 	case MSR_IA32_TSC:
>         	kvm_write_tsc(vcpu, msr_info);
> 	        break;
> 
> That got changed by commit 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization
> on guest writes"), but I don't think the guest angle is actually relevant to the
> fix.  AFAICT, a write from the host would suffer the same problem.  But knowing
> that KVM synced on guest writes is crucial to understanding the changelog.
> 
> In kvm_write_tsc(), except for KVM's wonderful "less than 1 second" hack, KVM
> snapshotted the vCPU's current TSC *and* the current time in nanoseconds, where
> kvm->arch.cur_tsc_nsec is the current host kernel time in nanoseconds.
> 
> 	ns = get_kernel_ns();
> 
> 	...
> 
>         if (usdiff < USEC_PER_SEC &&
>             vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
> 		...
>         } else {
>                 /*
>                  * We split periods of matched TSC writes into generations.
>                  * For each generation, we track the original measured
>                  * nanosecond time, offset, and write, so if TSCs are in
>                  * sync, we can match exact offset, and if not, we can match
>                  * exact software computation in compute_guest_tsc()
>                  *
>                  * These values are tracked in kvm->arch.cur_xxx variables.
>                  */
>                 kvm->arch.cur_tsc_generation++;
>                 kvm->arch.cur_tsc_nsec = ns;
>                 kvm->arch.cur_tsc_write = data;
>                 kvm->arch.cur_tsc_offset = offset;
>                 matched = false;
>                 pr_debug("kvm: new tsc generation %llu, clock %llu\n",
>                          kvm->arch.cur_tsc_generation, data);
>         }
> 
> 	...
> 
>         /* Keep track of which generation this VCPU has synchronized to */
>         vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
>         vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>         vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
> 
> Note that the above sets matched to false!  But because kvm_track_tsc_matching()
> looks for matched+1, i.e. doesn't require the first vCPU to match itself, KVM
> would immediately compute vcpus_matched as true for VMs with a single vCPU.  As
> a result, KVM would skip the masterlock update, even though a new TSC generation
> was created.
> 
>         vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
>                          atomic_read(&vcpu->kvm->online_vcpus));
> 
>         if (vcpus_matched && gtod->clock.vclock_mode == VCLOCK_TSC)
>                 if (!ka->use_master_clock)
>                         do_request = 1;
> 
>         if (!vcpus_matched && ka->use_master_clock)
>                         do_request = 1;
> 
>         if (do_request)
>                 kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> 
> On hardware without TSC scaling support, vcpu->tsc_catchup is set to true if the
> guest TSC frequency is faster than the host TSC frequency, even if the TSC is
> otherwise stable.  And for that mode, kvm_guest_time_update(), by way of
> compute_guest_tsc(), uses vcpu->arch.this_tsc_nsec, a.k.a. the kernel time at the
> last TSC write, to compute the guest TSC relative to kernel time:
> 
>   static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
>   {
> 	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
> 				      vcpu->arch.virtual_tsc_mult,
> 				      vcpu->arch.virtual_tsc_shift);
> 	tsc += vcpu->arch.this_tsc_write;
> 	return tsc;
>   }
> 
> Except the @kernel_ns passed to compute_guest_tsc() isn't the current kernel time,
> it's the masterclock snapshot!
> 
>         spin_lock(&ka->pvclock_gtod_sync_lock);
>         use_master_clock = ka->use_master_clock;
>         if (use_master_clock) {
>                 host_tsc = ka->master_cycle_now;
>                 kernel_ns = ka->master_kernel_ns;
>         }
>         spin_unlock(&ka->pvclock_gtod_sync_lock);
> 
> 	if (vcpu->tsc_catchup) {
> 		u64 tsc = compute_guest_tsc(v, kernel_ns);
> 		if (tsc > tsc_timestamp) {
> 			adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
> 			tsc_timestamp = tsc;
> 		}
> 	}
> 
> And so the "kernel_ns-vcpu->arch.this_tsc_nsec" is *guaranteed* to generate a
> negative value, because this_tsc_nsec was captured after ka->master_kernel_ns.
> 
> Forcing a masterclock update essentially fudged around that problem, but in a
> heavy handed way that introduced undesirable side effects, i.e. unnecessarily
> forces a masterclock update when a new vCPU joins the party via hotplug.
> 
> Compile tested only, but the below should fix the vCPU hotplug case.  Then
> someone (not me) just needs to figure out why kvm_xen_shared_info_init() forces
> a masterclock update.
> 
> I still think we should clean up the periodic sync code, but I don't think we
> need to periodically sync the masterclock.

This looks good to me. The core idea is to not update master clock for the
synchronized cases.


How about the negative value case? I see in the linux code it is still there?

(It is out of the scope of my expectation as I do not need to run vCPUs in
different tsc freq as host)

Thank you very much!

Dongli Zhang

> 
> ---
>  arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c54e1133e0d3..f0a607b6fc31 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
>  }
>  #endif
>  
> -static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
> +static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
>  {
>  #ifdef CONFIG_X86_64
> -	bool vcpus_matched;
>  	struct kvm_arch *ka = &vcpu->kvm->arch;
>  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
>  
> -	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
> -			 atomic_read(&vcpu->kvm->online_vcpus));
> +	/*
> +	 * To use the masterclock, the host clocksource must be based on TSC
> +	 * and all vCPUs must have matching TSCs.  Note, the count for matching
> +	 * vCPUs doesn't include the reference vCPU, hence "+1".
> +	 */
> +	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
> +				 atomic_read(&vcpu->kvm->online_vcpus)) &&
> +				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
>  
>  	/*
> -	 * Once the masterclock is enabled, always perform request in
> -	 * order to update it.
> -	 *
> -	 * In order to enable masterclock, the host clocksource must be TSC
> -	 * and the vcpus need to have matched TSCs.  When that happens,
> -	 * perform request to enable masterclock.
> +	 * Request a masterclock update if the masterclock needs to be toggled
> +	 * on/off, or when starting a new generation and the masterclock is
> +	 * enabled (compute_guest_tsc() requires the masterclock snaphot to be
> +	 * taken _after_ the new generation is created).
>  	 */
> -	if (ka->use_master_clock ||
> -	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
> +	if ((ka->use_master_clock && new_generation) ||
> +	    (ka->use_master_clock != use_master_clock))
>  		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>  
>  	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
> @@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>  	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>  
> -	kvm_track_tsc_matching(vcpu);
> +	kvm_track_tsc_matching(vcpu, !matched);
>  }
>  
>  static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
> 
> base-commit: dfdc8b7884b50e3bfa635292973b530a97689f12
