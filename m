Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9350387ACD
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349862AbhEROOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:14:54 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:16065
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349854AbhEROOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 10:14:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFUMoUdQ8CHeN9IASfFyn9tuepWkgaA5yWR91khQv0Pwz8udT2nANeP2GvJfrwRdE2ipQ4dfrK4LrAHVxUCBVSMmZO+7R3i2YmoVB1avJFekiOGrrnsHdj60CVehi2FqXpINWl8mvzpcCeJ/Zxf18SBPtUn37FeQpoENqafO68WWK+f2SUYz+pLK24j1GMH+aOr7w3ujAWc7I9D+OBV6zKacDtcQms9URg1mrCSqxPJNHMbXJe9hFZAzyoWamlO/NnEeUJic/cUo3SslbcouKcQdh8hLhfjyOOTK4LkOEnlYy4Usuixe93hmDqlRYuom+jPmFci65RZhTpdY0RuKpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VibhyNhihDnBNhZBwGjahmRhVZ5QweCs9DJqR0gHTc=;
 b=avfqJBa1rgGtDbSaHT34nOvq+GS6IwTUkqW+JKVr28bAIl78Jz330YEgn9XpJcwKnSEgi1vmW71VxPqNJ5OyzylBU6yV4Pd5qM16DCHXnjg0GgjZxp/WyCwqbTo8ksxfyXCGZ2CWJUa66CzLqy7cxv/gYqlE4WyGcrIXA2U0zqNLXfuQ9rKusS+0scKYs8XsktHFWBhRShGrHUYHRcdq74FlcTuN51T6iaMyNqH3nNJAhqlvAct+bWz2LdZAvTovNFcOsu/AlXxgC/fO28y5Cn2pP+rd7Iv52XhJ4iYClZQAr8vgkgvvsBlRRgys5rnEa1UdvwBTeakZWhdhTNjj8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VibhyNhihDnBNhZBwGjahmRhVZ5QweCs9DJqR0gHTc=;
 b=RjKa/8HbnyAGxNuA2j8UpIQCIumtWJxk70w9iyK0wpfLqfaygJo+qwMoyTd6ea3ttaiIU8LkaPx0w4J1Q1vzN/RWyUf82A3rdietjxRX79oviMhYB/wxX4Lgk84tUsAsFEBtT9Kn+Nvz/u9lsbkXYFPa2fp0c/iy9vq4W2HPTZY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2543.namprd12.prod.outlook.com (2603:10b6:802:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 14:13:24 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 14:13:24 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 06/20] x86/sev: Define SNP guest request NAE
 events
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-7-brijesh.singh@amd.com> <YKOaxBBAB/BJZmbY@zn.tnic>
 <d6736f33-721d-cbe5-eda2-eab7730db962@amd.com> <YKPHFXR+3t1HM38S@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d41a4973-018f-fe5d-5083-894b664acbc1@amd.com>
Date:   Tue, 18 May 2021 09:13:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKPHFXR+3t1HM38S@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0197.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::22) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0197.namprd11.prod.outlook.com (2603:10b6:806:1bc::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 18 May 2021 14:13:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c902e25a-56bb-4f45-4c7f-08d91a071943
X-MS-TrafficTypeDiagnostic: SN1PR12MB2543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB254399DEE3A2FCF31202DB11E52C9@SN1PR12MB2543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0DCz1nKVU8HL/6D03bYW7KM5K7hPx+ASRjP1Z+GnnfNmbLEwetDQx2k19gFfXMHj2JslIy+yI51Xexwkdmaafzpb2NTz/CS4GByEop49Q2E9O/dPGYnpxW3wH+CwdVBogULfV4k0sJSEhOUNUx0WvHs4RSZPAem0zLdXwj0Hcu+Haq1Y0W3vfPV3bcxp6pSfq7C5wdKCdlFp4DfRDbDBE8HQcIoJz66dEunY97WBIwyG2LR3d6rbkQtmROM+Da8eQ4YSN5wMnDcQoh5I6E5EqdQu8sWpspmOUzXD1SEnF34ALKLuGNNQW1EGesihHjyhK+dj5JPKUZcrKF6RvtG/piTGvjPECtlZQewUbtMpoayjEWa88sH9AR43CBvVsu2YkDf2W0N5kDh3f45cEKSyC3KFrXInOp34mSJFRyrZ6vAVY3lZJzkJIAYJ7XBJl28645cn6grf9aWHDvynDp2PjAP9vDc7MbslhZvO78nFSSiRk1sqMa/kxmeItd62RT3mkVM8Eih7GeTaHlYVE5/8t4ymdyf2KvDsM0GkVxPMv2MQo/0P1qKqiwEg74sP5yRwKKrLIqCBzx3I1+TVpzZwqDSCF0X5cBnY8g0LxUYVcLHJ4F0SiJ7+WWg8IWxtmlxRPHc4CEo6grn2dyQLzcQi0xk3Qvc86weCpphBxoORSPEAYodRkYgL8xNmu5i9zYI9Fr6oidM3rpsec35pFJ8veHkAJvWzBbd5JVE8AmqURM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(4744005)(4326008)(8676002)(53546011)(8936002)(6506007)(31686004)(36756003)(44832011)(478600001)(6916009)(956004)(26005)(52116002)(2616005)(5660300002)(316002)(66946007)(66556008)(6486002)(16526019)(38100700002)(2906002)(6512007)(86362001)(38350700002)(66476007)(31696002)(83380400001)(7416002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2cyWDdRVnNVdUhTOEg1ZUoxRms4TlBlYUxnQkttaEdFVHF1TjI4cmxaNzlY?=
 =?utf-8?B?clRWcjJvMTdZSklSR1M4V3FCOVN0ZVVHMlhaLzdzQU9EZWYxTTBGSlRMMmlP?=
 =?utf-8?B?NXd2MXFYYm82ZU1kaXhYSHBGdjZESmllc0pWTVRuMG13b0Z0bmFqUUdWUjZy?=
 =?utf-8?B?SWNhc3BhenVMZFA1MmkySjVxdkpZajJUZTRYSDlwekxKMVRKTFpPRHNOeWpV?=
 =?utf-8?B?ZWhVVFZOS1RBQ3RWeS80Z2FkRmJYNHk0d2QvMUJDNFhtTVE4cDg1dDRvcnRD?=
 =?utf-8?B?RXFwdmsvaFduY0kvY2Vzc3E0UmJicUoza2NHQ09iRHFOTVYrcU5SYnBOLzJm?=
 =?utf-8?B?WkwvNG1kOWtTSDdPVE9lcEVRQm55Wm1Ga0VBQTJ6WUZPL25KM3p4Z082OXlE?=
 =?utf-8?B?RGVMUlJZVlM1Si96azJITElMelVOYTBaQ2R3d3kvVWRLQTh0eU4yZTcrK05G?=
 =?utf-8?B?UVEvK3FienFmcnZTdFV0dGV5MVErZHRsR3N6Tmx3dXVRZWk2SHpXRmlmQjg2?=
 =?utf-8?B?MHBwYkhDdnRuRDJZMk95VU1HanY5b3d5WkV6ckN1MklJU2tDSHdybGtIS3Rx?=
 =?utf-8?B?TmlWOFd2eGlmSXF5NXpQZm9HQ3NQbUZucFNCZHVvQ0pEdk9scklONlh3amVF?=
 =?utf-8?B?VlZZVWhKUUxHaUd1RnhIZ2FTZXlPWjBvcU9VcU1jOWtCYmIvd0V0RmFsWkE3?=
 =?utf-8?B?OG5xWWZxbTdUTVdOUUd3STRzeEppcmh6cnBnenpLMVZ4di9BY1Bxb0cxNFpO?=
 =?utf-8?B?b3BCQmVrc3NPbkE3aHFxKzBXOGg1dGs0Yy81SHF3UHFSb1k4dzRHb0RuVy9C?=
 =?utf-8?B?SEFsTjRHaUx5dnBuS2IrMC9lVUtmK3F0REJqd0FDVWxoMnhPb0hha0hkcHJJ?=
 =?utf-8?B?cktqWEdqdkl5Tm92SkUyN3liOVRFdTc1Q0dBU2hQUElPYXd0NjJQcXdYc0hY?=
 =?utf-8?B?K3pudEdwdDJNM1lja2JnS0xETHFRNHNLSVlOditHc01lYmljeHJBRjdRZ0dE?=
 =?utf-8?B?eTJZQy9MaU5pSmtNSVF6Z3F1VGhmZm00S0poOTV0b3IzYmtvSThBVCtSYW1w?=
 =?utf-8?B?VTZUTitrSmlKY3NDdHQ5Q01rQU84OS9ibG1tOGRlNTNwVlI3NnZ4b0ZFb0Mz?=
 =?utf-8?B?SmtlRzd3SG9RRVJxY2l3T0hHM0tEeDJiZ1lvZnN0L0d5K0p4cnF0ajRJUTlL?=
 =?utf-8?B?REMyalMvZERRem1sM2JSWDFxUHEranM0ZG9JdVNJcW9UL3NXTEJUMGJzQnVU?=
 =?utf-8?B?UnM3UUVBSkJ3aWt5ME42bXhISW0rUU82aDI1NzlkQTBlRDNVdXV4UlowZTZz?=
 =?utf-8?B?WlFzS2QzQlRzdms4WGp0NEZXcU9wZHZQalhqUS96YWh5ekJhbU9kcDR6eXNT?=
 =?utf-8?B?cnhML1ZuN1RWWnh4b3JCL2s2ZHdHdjNnc3dRc2ZpRkhEeTVhdXN2K2k0T2d1?=
 =?utf-8?B?eHloQjJWRm5VcUg4aUZETDBUWlZxK3BKQ2s4eGJ6STZSMEtxL3JScnk2YXJh?=
 =?utf-8?B?WWlVcU1BOU1Tb0dCSEhlK01jM2wzT1FBOFNjcS9jZ3pDVXpWTThEY3UxY2VK?=
 =?utf-8?B?azMwUkx5WmEzSmZBMFR4RE5mYmpmbklBVUtqZXRyR1pRcmE2SVZERkRPQmUz?=
 =?utf-8?B?ejhlSit1bldjNXVFZHZNL2k2ZVRudUhkL015U1ZPL01KMitLWi9Pc0dOa3o1?=
 =?utf-8?B?OWpMVDdKV3E3djRpNU4vZlhNWGloRWdvYkFvQ3cxWk55TldKNXZnaW03NS9U?=
 =?utf-8?Q?+ZvfvVbi9s8iH4uOuW1rfRNfAJdUxTIi7fr6+OW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c902e25a-56bb-4f45-4c7f-08d91a071943
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 14:13:24.2308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+Xb5itTtMxJD1Lo/VTw6/y6r6MnIzE2eEsRd3Efg9nZJaJw2b0PSc7gXVhHD6GEPL9swbjsemPVqDgh2kH2zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2543
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/18/21 8:54 AM, Borislav Petkov wrote:
> On Tue, May 18, 2021 at 08:42:44AM -0500, Brijesh Singh wrote:
>> This VMGEXIT is optional and is available only when the SNP feature is
>> advertised through HV_FEATURE VMGEXIT. The GHCB specification spells it
>> with the "SNP" prefix" to distinguish it from others. The other
>> "VMGEXIT's" defined in this file are available for both the SNP and ES
>> guests, so we don't need any prefixes.
> Sure but are there any other VMGEXIT guest requests besides those two?
> If not, then they're unique so we can just as well drop the SNP prefix.
> Bottom line is, I'd like the code to be short and readable at a glance.

There are total 7 SNP specific VMGEXIT. I can drop the "SNP" prefix if
that is preferred.


> Thx.
>
