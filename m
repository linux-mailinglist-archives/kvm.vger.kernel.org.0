Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF415433C9F
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 18:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhJSQqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 12:46:37 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:30794 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhJSQqg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 12:46:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634661862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+UXs59PfxlDLfxEDdZpuzZBYrgVeu0smsG9/aDekGwc=;
        b=ZCDEhQ0Rc3JlNd+H18v5z5x3gckzhQr01bSNSA84xhwofy/Q1TC+kUslVVI47rnYjbiGZ+
        afPFYTwK5j6QXx9Svluk0dcCmDBZFOczWStN2D21QsMhDXlBpUSReZ4Cr2pQAMAzZFEDz7
        SYJSyAZX4orTu53noPSBPhOMDJT84Ng=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-0rWpgvtwNoWQotLQYuhT8A-1; Tue, 19 Oct 2021 18:44:20 +0200
X-MC-Unique: 0rWpgvtwNoWQotLQYuhT8A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXWWDt8CPWLbomRuyenDOMa1MWXN+ryQQU4XGfoutjX1tDHzTOHIfyrbqn/xmT0SeG1DdC8safdqT7AzRK9GFoZE3WkerCjSdNNxnyZPAr/3dTj4NMFczvpGYrJCAKgni3alkkAMv9zZuPgUs+Feh/kfPzsR9l5PukGkIxvIQ1TWzcW5++eXkxacUckPvdF3xT1VMAmuyWJeYBetoH6Jy+FZvygmIEoC/flum5MssC+3CPbVtYRuZ31sITormN8dQUc201Qr++qSdwuNBrIqrC2LWObl/zb082Fk7110Bu1zsGgIKfoZ4y1bgdYSahy1PinPfEASRyKp7nbe+Gwjcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UXs59PfxlDLfxEDdZpuzZBYrgVeu0smsG9/aDekGwc=;
 b=fL0tbQCIa0WXROc9CQMQ0N53YQYpoercj+chCQXsV3LZU3hhgHOxzprNTt8f9mSeAJL3w7jyb358kXwWmbFF/Yp9BnlB6QfnSjYU+gE2bQAvQCOelDf19nHhIt/c29CXNQoCzifq1XfcCYeCEdfZNlo1w73gZ6sX9jqu9ZnnEX2wdI5pbdW0i4UvyZMsnyi1F/HHY9M13f2L6HZa/MNYSR+kwXijW+buA4upizPhcptyJMBVgUPvAW7pgEdOV/yp39PnjMj4qockhxCRePTGFwKhmW6TytQH0iqC+As5uU0jLKUeRbcTWNFMQTj6X1V7NpmiIAjJUhfmZgbn3tEfdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM8PR04MB7892.eurprd04.prod.outlook.com (2603:10a6:20b:235::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 16:44:18 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::80b4:c12e:2fb5:8b30]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::80b4:c12e:2fb5:8b30%3]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 16:44:18 +0000
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
To:     Marc Orr <marcorr@google.com>, Zixuan Wang <zxwang42@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
 <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
 <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <32dba144-e0d4-6d91-5f79-6ed47fea6421@suse.com>
Date:   Tue, 19 Oct 2021 18:44:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0135.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::22) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
Received: from [IPv6:2a02:810a:8d40:4cc8::7190] (2a02:810a:8d40:4cc8::7190) by AS9PR06CA0135.eurprd06.prod.outlook.com (2603:10a6:20b:467::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 16:44:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7bb94ed-e429-4df5-26c4-08d9931fb19a
X-MS-TrafficTypeDiagnostic: AM8PR04MB7892:
X-Microsoft-Antispam-PRVS: <AM8PR04MB7892F21191811EE3FF3B9937E0BD9@AM8PR04MB7892.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RRgyH/xKoyF0XSUwQqZhXzpfsvus5VU8KT7Ol5FFWTc1oP7EdsniaHB8lQFJLCBv4JdBGo4tC9nhXTJ57YIhcgHEuZDp/n7ODFSNPufAhyPLFVJR2CSy8HT8bjNIXpwTA+F0G57GqoBqjPzU4KBoUf5n560hpfHo3P083m+2q1DB5yKs2yu+r7Yu42Ne0XwA7li5+4LpWmFOKcB0HRoWWGNv6ntSFysNm3vihwE9bzj+2CbMfbSZzahtcvBOaD2igMX+bwKtQhr01XbHLZ8DRe7cZ+pHjEHKi9J9suDbza6ZfRUupTD9GcnzSm0s2NO/ORa3POE9r0e5xpbiuGLed9EBmkM0ejh5mpgB/7oWG3YfEiuemo//+8lrehLruOJ9+Kujwl4KrCLkL4FJCDCPPgSe2ENhEUnw9Wkrmr+GRNLOY9GoV4WG4/UbtfskBVfdDV9stUcePKYXjlytGhAbB3YG8dEccCFJHp6mo/ZmuCInX1BBy+u0ZhQ7lv7NEOIaxmxUVJiYJgDk2LtjP7+qF1wiVA+dtnm/XAZFMv9KtukNPKSU3p1YUMz+mBbDllI6HZWo5J2R/GsiqneprmOOTK5iLiW+nZe90lErrNE0bsqUJhZSsm5le8oh/uz7TC7PAzI2/lzL3ZldC1Cfm7+Usf1UFSwWZeYTNPi6OJVHDMok+LgnCI9DiFY8dvu0nAjt9AQeqmPJiLkI30+0ior+CyhXiRUFopGYrFFzDe9QaNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(316002)(2616005)(86362001)(66476007)(54906003)(2906002)(31686004)(36756003)(83380400001)(38100700002)(4326008)(31696002)(110136005)(186003)(6486002)(508600001)(53546011)(5660300002)(66556008)(66946007)(44832011)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2x6ejZsT1h3VGxiQWdEWnhPNnNlYk9xcStwekVjNFVOaENJODJ6ZGJsekM3?=
 =?utf-8?B?T2ovSkpJRGdzZDlUOFprOU9XblJsYVJoZHhva0tjaGpWVVlwMTFveG9Ndzh1?=
 =?utf-8?B?THF2YTVXWWtYRFFJN2k2QTVyUTJFalRkMVlPVHVXWUZ4QTZkemx4RFVJZHVJ?=
 =?utf-8?B?QndlL01GTVVVd09EWDhRalR3WWY0bldRSVpySTBoYTBFcGVrYTZQNS8xaElU?=
 =?utf-8?B?ZTdWMk1LbTlBNk5FeVJUVFRYZlpXUkg3VmRJQkQ2WjI0anpna0J5cjl6VUtP?=
 =?utf-8?B?ZXBiUnYyWUdlOXVxM0ZsSUV6YzBZSXJuTE1hdzZPTVoxZmhETVQyK2s5dlk4?=
 =?utf-8?B?ZmV3elpaTEJab29WSFFqWnVJeFQrMVNYR0dhOFk4Z0RGNkJPZXhmRVRRamlB?=
 =?utf-8?B?N1V1dmUxUGg0VkFZVlY0Y2M1VUQ5RmFqbG5iSFF6bk1wKzJhUHN5OWszMzRH?=
 =?utf-8?B?KytCd213bU5tTWxaMWpxOURyRkxwVjB3anZBZkNxa3JNR2tlRlhqcVM3YzBU?=
 =?utf-8?B?S0NYR2txYUlpTFdkdGdHRjEvWXFueTBJNW5CWGV2Z25LYVlnU0pnclEzTFA2?=
 =?utf-8?B?Z3NSb011K3JKYTJpbTU2Nmw4bmdqSFBxakZEVnloSjRGWTZseEhCYUJQYmZu?=
 =?utf-8?B?SE1OK2VCbDVvcUZ4M2JXZjlxTDlQcWs1Y0Z5SjRaR3cwK0NvSmhiM2duVDdN?=
 =?utf-8?B?K3cwYVIzR0wyamRRY3dPTE1nZ1FPZWkvWkpia2NpaENMQXA1L0Q0b3Y2aXdS?=
 =?utf-8?B?ZUp4dStIMTBJeERRbWl0VGVvRlNBUDljUE5aMm1iRzlXRzhSNit3aG5zdXUx?=
 =?utf-8?B?RTBUK2hjZm5peFFvTTEzT0gzV3NpZG9kRWppTEtqWllHNVJGT3U0R3hhdmpN?=
 =?utf-8?B?N3pCcC8veTVkNTJ2UWIyWEYzclJTUDc2Uy95a21rUVVUeDFHRXk5TDJVbW81?=
 =?utf-8?B?NVNrSENVMFFzYzEybHFpSk9kUTR4c3g5dnI5TUt4THQ5citjZnFFZU9jN3dj?=
 =?utf-8?B?WUFzRjZMQ1VDKzkxY05rbktSRVRoSzVTajBIL2FpYjdwZUtqVDQ2NHlxN1dy?=
 =?utf-8?B?Y2libWV2ZWYxUUcvVWFXUVliRkN2aTBPb1F3SE1BM1FLenlUQzNVeXBzai9J?=
 =?utf-8?B?N09EUmJKUDVmM0I2SDRqU3ZTZ2hYVzIvTHI0R3lwN1ZvbWh3MitKK0FvZzRv?=
 =?utf-8?B?SmpZTU4vb251TUk4ajF1NHNxRkE2Ni9aTmE5SHhsVHNTTzVHRVYwU0J0VDR6?=
 =?utf-8?B?bmpRV2ZZaUt5WnhGYVZQMVRpUDVxMkdUdmV6WFRCeDVNRDNYa1BrM3ZTb0NE?=
 =?utf-8?B?SkhnN09hKzBoK3hObDJHVysyK0RsWHB1cjF3eHVnQ2d6R1RPNDhGbm84UXpq?=
 =?utf-8?B?bG1LS2hoSWJOUXJTMkVOVU83akRETDVRcFVWVG5HK1c2ZG91clJOaHN0aUpT?=
 =?utf-8?B?TFhJUHpZMFY4WmVTZ1dobHRNclpHU2oyRGtpVjNVczBuN3pjK3VTa1FTYzBl?=
 =?utf-8?B?L082WXZCNzlNclJGOUdvdVlla2dpOTlXMGlreW9JSmgxRmMvR1FmNWtmVity?=
 =?utf-8?B?M1BoL1FCeC9YREJCcEV5dlBYRkVrSTJ5aEo4OU12aFROdUlGOFRMYy9aS2g3?=
 =?utf-8?B?bHU0TndNSStUc3Nqbm9KaHZmblladkNGVHNVbDFlWG5hNWROejArMzV0NGN0?=
 =?utf-8?B?UEs5a2tUVE1ESlBLdklHYWtoemZSdmx1aDdMRFBrWXBMWXJkMXB2Mi85SHdH?=
 =?utf-8?B?cm9MVTZIemY4cmJEbUozOFpJMUVMb1F3Ym81ZmtmWlBQRUFPeVpIZmVreTMy?=
 =?utf-8?B?TFR2QlFCdm1wZXQzOG9Vdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7bb94ed-e429-4df5-26c4-08d9931fb19a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 16:44:18.3854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDKy/GmVq2vdB2QU1XSEyINsXQD3zXQZOmogG3l0hlgmInCRRvBs52IY0XAnmtt8LWk1boFaMhZxqWwW3pMl8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7892
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/21 4:14 PM, Marc Orr wrote:
> On Mon, Oct 18, 2021 at 9:38 PM Zixuan Wang <zxwang42@gmail.com> wrote:
>>
>> On Mon, Oct 18, 2021 at 4:47 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>>
>>> Hi Zixuan,
>>>
>>> On 10/4/21 10:49 PM, Zixuan Wang wrote:
>>>> From: Zixuan Wang <zixuanwang@google.com>
>>>> +static int test_sev_es_msr(void)
>>>> +{
>>>> +     /*
>>>> +      * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
>>>> +      * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
>>>> +      * the guest VM.
>>>> +      */
>>>> +     u64 val = 0x1234;
>>>> +     wrmsr(MSR_TSC_AUX, val);
>>>> +     if(val != rdmsr(MSR_TSC_AUX)) {
>>>> +             return EXIT_FAILURE;
>>>
>>> See note below.
>>>
>>>> +     }
>>>> +
>>>> +     return EXIT_SUCCESS;
>>>> +}
>>>> +
>>>>  int main(void)
>>>>  {
>>>>       int rtn;
>>>>       rtn = test_sev_activation();
>>>>       report(rtn == EXIT_SUCCESS, "SEV activation test.");
>>>> +     rtn = test_sev_es_activation();
>>>> +     report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
>>>> +     rtn = test_sev_es_msr();
>>>
>>> There is nothing SEV-ES specific about this function, it only wraps
>>> rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
>>> Since the same scenario can be covered by running the msr testcase
>>> as a SEV-ES guest and observing if it crashes, does testing
>>> rdmsr/wrmsr one more time here gain us any new information?
>>>
>>> Also, the function gets called from main() even if
>>> test_sev_es_activation() failed or SEV-ES was inactive.
>>>
>>> Note: More broadly, what are you looking to test for here?
>>> 1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
>>> 2. A #VC exception not causing a guest crash on SEV-ES?
>>>
>>> If you are looking to test 1., I suggest letting it be covered by
>>> the generic testcases for msr.
>>>
>>> If you are looking to test 2., perhaps a better test is to trigger
>>> all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
>>> and check that a SEV-ES guest survives.
>>>
>>> Regards,
>>> Varad
>>>
>>
>> Hi Varad,
>>
>> This test case does not bring any SEV-related functionality testing.
>> Instead, it is provided for development, i.e., one can check if SEV is
>> properly set up by monitoring if this test case runs fine without
>> crashes.
>>
>> Since this test case is causing some confusion and does not bring any
>> functionality testing, I can remove it from the next version. We can
>> still verify the SEV setup process by checking if an existing test
>> case (e.g., x86/msr.c) runs without crashes in a SEV guest.
>>
>> It's hard for me to develop a meaningful SEV test case, because I just
>> finished my Google internship and thus lost access to SEV-enabled
>> machines.
> 
> Removing this test case is fine. Though, it is convenient. But I
> agree, it's redundant. Maybe we can tag any tests that are good to run
> under SEV and/or SEV-ES via the `groups` field in the
> x86/unittests.cfg file. The name `groups` is plural. So I assume that
> a test can be a member of multiple groups. But I see no examples.
> 

Right, from a fleet owner perspective I can imagine the following scenarios
being relevant to test for a SEV* offering (and I guess hence make sense to
have a special test in kvm-unit-tests for):
- CPUID shows the right SEV level
- C-bit discovery
- GHCB validity (protocol version etc.)

Generic kvm behavior is better tested via the other dedicated tests, which,
after the EFI-fication should be no problem to fit into a test plan. The
SEV* implementation can then go through the whole battery of kvm-unit-tests
plus the SEV* ones.

Regards,
Varad

