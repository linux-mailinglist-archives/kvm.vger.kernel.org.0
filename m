Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB9E4B51B4
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354186AbiBNNfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:35:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354233AbiBNNfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:35:02 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FF95714E
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644845692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EaHOhkMxRg1IJcekgtK8RCAzLdJQQbZ8h9jnLIChgFE=;
        b=gTEg2Ln67mBHsHIFQaY22JMzJzujlE8Z9akBE0AcEkKg5C85309zaZSj3tya98e0AwySVL
        9k0Zee+U+05yNaWeZEKmTS9FveJ0qOg5fgn4dmXJjB4ZVF18n2oZkgQnqTajlWEWzcPS+K
        m99M+l8zhsyszmw75V2heKj2Xmu3Ppc=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-6-PwitQ4MsNJuHWpR5b6XjZw-1; Mon, 14 Feb 2022 14:34:50 +0100
X-MC-Unique: PwitQ4MsNJuHWpR5b6XjZw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGy683AKg9ChxitccjZkWsUQxzuqT4mTA6d6bua1k9AHw3HZ5wFnC5em6IIxxwXR4EbvQkj64LAXZK3sGwK5QQQWFb7YPeKw/1jZK6u5MHF6tiunprr2Wi+iK9yA0bPWWceK4jh/1sgOo7he0dBjEkf9LjmINA2VueSpUpr43pwGCG2q/mEIkKUrFH7rMq6UWflrLyQkgROKwJ5ha3qHGgv2RR9GlSIYASyiJmp3cOhsY5954z6R5oeW0+0kSiPU9/o0W2dKrzAPkBczisuSMqHL9FRzJUIwbtnGhWv3oidYs6b2cpNmgyp8ceDop/kUROE5sTyCfk8CQbW5MhMeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaHOhkMxRg1IJcekgtK8RCAzLdJQQbZ8h9jnLIChgFE=;
 b=Pl5XIr7nukaEtopJw+Eryb/m+nF6N96/obAgfqTm/iWfUnUwHslsm58AgfM1CiKwSXtXZJxqPN2k1C2hyZUG1yPfUUCq5QSgpsww5yr0zLLb2/rT9ZagyLIfAA64M0m6T2v6MT/0mjgvUL5iON7FaTuJJ01F9K9vwNFn9qu4vx84ZpZ6NT1Ta2FVmYRqlC5csHDyuME+7XoOVE1/4to6qqOWUNPXGqgUe2Tlnm+vKyjHNkFFW/Uwb9N+9Pc0dP5xFTAHJ8pZKA8SmU+iHk5pUdMBLjBWWo8wHwRxAqju5nyl4Jc1a8DD6Kej3Sn94MqehjwY2RbeLpbLxok3gV+UFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by VI1PR04MB4270.eurprd04.prod.outlook.com (2603:10a6:803:3e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 13:34:49 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6%4]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 13:34:49 +0000
Subject: Re: [kvm-unit-tests PATCH v2] x86/efi: Allow specifying AMD
 SEV/SEV-ES guest launch policy to run
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20220209164254.8664-1-varad.gautam@suse.com>
 <CAA03e5F0yDkaKhL42LKreLGyiy5gwZvtS4YR9q-ZFpqt2uxqnQ@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <f32b32b3-2a47-209c-ea25-31d1af61a57f@suse.com>
Date:   Mon, 14 Feb 2022 14:34:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5F0yDkaKhL42LKreLGyiy5gwZvtS4YR9q-ZFpqt2uxqnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0301CA0033.eurprd03.prod.outlook.com
 (2603:10a6:206:14::46) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ed0e246-ac43-4757-7e11-08d9efbec54e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4270:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4270919179C594A10B3BB23DE0339@VI1PR04MB4270.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CM65VuOPwT9qjUvX+YAfoHqlg/1okKDsxfNag72IuZOkfXZu0pyGGBu0Bm2YreQWdBxTcmo4EW0RTzwA3JmC+FNcVgbco/XML2yPMXBgj1UfkIu/+Fl5fjP3Hck90NVmJcczEk3gk0yeJ2ITllaGJNPdxaif1fd6KiS5NKwkwnLY3s87fN4kFJQbwk5sEwyusBU/8ptwdEfgsDfhYXHniSDNiCiHTlZLp5n5uvODoPqfBbHo5GPfV+uMJ7Dx6P8DUKJBhfy+whpmFFj7U+bxtTnPo+ZaxkvaP07s0j9T07PNeHSMNOYltA7rDy92PBPzxYwlkz1+fwDbBesBwpwqGiPEsAacJocSw6ahipoL8ArH3DCaG2Oi3uGEN5ObUL/3cMOXXdismDG/7oRDNw+b23J0bKrIiZ5qBC06teVcqOeWKmE73MWQzFEZ4LVH1jiNs2Agg9wxMrMKysgKW6OSJKXpg9f7fv4xVMrELjF2KwT/IHtLpEdkqqZy6NrqRNl3QRYZStKGK+17EbRCZRt+erpgSpPghDqzIHL+s0ohwX56NAKdsY+W/fZUAHwpmwN5lTgayJuhwatHHJ0gzNWisWBDBIgoPYU+URJlNgw51w6MQ9FXvgCoe9/yRlZse7LxODGSLe+ecq/1PfLizyukrDy+HOHpUHfI/+WJI3c1jpn7WixPSZ2bZ6dZJeYb7OEPJAoTyB/WH6QxWYIV42lwxNS6LavFugnEKD9qB9byKluTZAZt8GaOGUksCRJV+kwWPIB0vVrN+Wlu7VfUrGRRkfap9sBl2ClKH2NatZ1YVR//YHMBa4V3NrgK6auJBvkgZglcmANhJ4xrQbBluBblV+Mqa6dBKmLPIg6SSoOrbIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2616005)(54906003)(316002)(2906002)(6916009)(31686004)(6486002)(966005)(86362001)(508600001)(36756003)(8676002)(44832011)(5660300002)(8936002)(55236004)(53546011)(6506007)(38100700002)(6512007)(31696002)(66946007)(66556008)(66476007)(6666004)(83380400001)(4326008)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1ZCblFzZlNoYUtOYW81NVFGMG1RWUtOU044QXcyYmI1L3ppeDZKL1pWTnp4?=
 =?utf-8?B?Y3N2N2RlRWkxTDR6eEllWnRIMTZQbnZudGtYbTZ1RTgrU3NabjhxenhxdSs2?=
 =?utf-8?B?N25CNTNybWF4aWxhRGFBMk5WUmJWQy9wTVZMVjQzejgxVGxUV1hJb0NLaEkz?=
 =?utf-8?B?T2cxV3pSdmh5S2RuV28xZkpSL2kzWHVXbkp0MDUxelA3NzFjUVlydFRBeVpn?=
 =?utf-8?B?V2dWaUVTU0JEUHZMTTJ6c3Vnek81b3lCZTJ1QlZSUmpoODRrQjhsNVdPcHha?=
 =?utf-8?B?VThQeGlkaXJJdkFlZnFvcFlxOC9PUXM5N1R5OE9xb3UrNDRhQkRVcEFjaXVX?=
 =?utf-8?B?TTN6L1BDOGovbHgyN0xsbmU4c3pIU0hVM2RRdVdETnNrOStKUzFaQlo0eFdu?=
 =?utf-8?B?KzdxWnJuVFR0YlY5YU0yNDk5Wkpnc3ZqN1NDZnl6bXI5Um1iVWNNU3drTFo0?=
 =?utf-8?B?dmZteEJPL0xMOGIzS3QrTDJoai8rc01HTzBpWDhOSk9kUlU4ek5lTDdaNjAy?=
 =?utf-8?B?UGh2SnZrQUdZWnRpc0FyMHFVWUVPVjBTODQvYnVkWTRrZEp2d01lbHBEUXNj?=
 =?utf-8?B?ak9TUVhVcXNsd0QrZGR0enROMjIwdVVES2wvbytOQnRXbHZRMUY4Ukk0YU9h?=
 =?utf-8?B?SVBheUV0a3BkRlFTb2dSYzdhTWpaYnNxMVhVQUQwdFYwU1hoL1AvYzBTTnVL?=
 =?utf-8?B?WDhWaFRobnNsUWRBcFUwenEwbVhXM1dhc3dpMnBkWEhqeE51dmY1d2wydGhV?=
 =?utf-8?B?YTgzUG4vaTljY1owNHN0N2RlU1lvcTFUVHlnVXVMNDVEVXNoSU8ycnFjUkJN?=
 =?utf-8?B?QVJUUFNsMDVLNEtBV2hIaHJicG93Y1NoQ3VlR3RzbFBPbFBCdHIwU00xbndj?=
 =?utf-8?B?RUdwdHNxRkREUWZGc3FLSGpJZjhmQyswWmtLYXJUNUZKNE43T3Z5U3ZKK1R3?=
 =?utf-8?B?WHYxWnZkWDJSYkFUVHpMUTl0QUNzczUyZFI2bnVNRlo3ckdiWERaaHEzVlNm?=
 =?utf-8?B?d0RCdEltR0dVeTBLTFhUK3RLQU5DUjJjcFQ3bVVMZllwZW82ZmxOUU0zUEV5?=
 =?utf-8?B?RnhOSldySy90eWhWWXlXdkI2YW9pWE9hYWJoc2RRTWlNWnN3UXlXcm15WTFN?=
 =?utf-8?B?cURrU0VCNHdrc2RvWVNlekgyWitmeWQydXljL1FpN04vMjdoanUvN2o0Rkxz?=
 =?utf-8?B?cCtITlhjdWtwRm1MWGxJMGo5cEVzUVluL1RIRkhtSkVlU3FnZjZPVVFjRFhH?=
 =?utf-8?B?bEJzSGVlN3hERzVLakVZUGpvWTlyOEtBYWZvTHdaVmcvQ3kzRWQzOXlVYmNL?=
 =?utf-8?B?eVgzdE44ZGxrcUl0dFdQYkhxL3NST1JQRGNFd0VsK1R2V240dEtzdSsxTU5L?=
 =?utf-8?B?c0JMUXlkQUZuTmg4Q1Jpb1dWa3dmZnkwMDRzMldzNTR2aHNJMXVtdTlkKy8x?=
 =?utf-8?B?enE3R3VoUHBkc2NOSFY3N3UxUnYyVkF5UC9RZHVHTVkySWpDYTRuVXNmeExZ?=
 =?utf-8?B?STRjQmhUcDR3RVVMaGVJMGo1cUVwTUw1ZHY3ZlU4bExDNGVFRTJadmJZUHlw?=
 =?utf-8?B?bEFWQytVbVFQWmtvT2d4TFFhYnJTbmN0NDZ1aW0xK0FydHJzK1l0Nm9mdG56?=
 =?utf-8?B?bGFhQXNORVd0NmNGRmdkTGVBVFdXTnljUS92UmpXVlhucldDNm9KeGdMeGJz?=
 =?utf-8?B?NlBIS0tpMUpDZ3pJSmUzanRWQldzbWYvYlB0NHN4Ulg2eXBSR2hvTnlOOVht?=
 =?utf-8?B?LzBRSTZYakdLVmJ0RkdiQllxZnM5LzhCaVM5MWtZOWN5NXQ3cmwrVWF0ZVNv?=
 =?utf-8?B?Z29ZQloxMkVFcFV6UmxDZ2VjRWZ3NzZleVNkVG4xc01GcnNndXJWNUYyTTdU?=
 =?utf-8?B?Z0dmTk53V0RRaXBVb0p3SWYrNTcxS2tYd2dyVlBrUlRaa2lEWm9ISVFYK296?=
 =?utf-8?B?QzBMVHZhYnc2RkhJdXI2VW9SVHYxdjNtZ0hXdW1vVm5ST2hLY01zSlgyUmZw?=
 =?utf-8?B?YndNaCtFVnUwLzlSTW42Wm1xcmhaT3NEellhSXdEeWc1RWlrZVlmVVBEMEJn?=
 =?utf-8?B?UmllNEZQa2V0NjJaMnc0Y3dLMHhobm11SEZJUHY2UGpuTG90STlzcml2YUIx?=
 =?utf-8?B?N2N2UXdmWjU4bCsweFRHMHQySnIxMU9pNHhQNFFBb0RQVDdQeUlFUmlhTkJ1?=
 =?utf-8?Q?KxJYUFz701kbDehPotvl8Eg=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed0e246-ac43-4757-7e11-08d9efbec54e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:34:48.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzo4YC1kmI+Mugpfx4BKkW2vU5VJck58vP5tezW/7UBCCjvPpGV4YfDrVEPYlgPIcUNM5FOjMIw8BRrUa3G05A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4270
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2/13/22 4:48 AM, Marc Orr wrote:
> On Wed, Feb 9, 2022 at 8:43 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> Make x86/efi/run check for AMDSEV envvar and set corresponding
>> SEV/SEV-ES parameters on the qemu cmdline, to make it convenient
>> to launch SEV/SEV-ES tests.
>>
>> Since the C-bit position depends on the runtime host, fetch it
>> via cpuid before guest launch.
>>
>> AMDSEV can be set to `sev` or `sev-es`.
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  x86/efi/README.md |  5 +++++
>>  x86/efi/run       | 38 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 43 insertions(+)
>>
>> diff --git a/x86/efi/README.md b/x86/efi/README.md
>> index a39f509..1222b30 100644
>> --- a/x86/efi/README.md
>> +++ b/x86/efi/README.md
>> @@ -30,6 +30,11 @@ the env variable `EFI_UEFI`:
>>
>>      EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
>>
>> +To run the tests under AMD SEV/SEV-ES, set env variable `AMDSEV=sev` or
>> +`AMDSEV=sev-es`. This adds the desired guest policy to qemu command line.
>> +
>> +    AMDSEV=sev-es EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/amd_sev.efi
>> +
>>  ## Code structure
>>
>>  ### Code from GNU-EFI
>> diff --git a/x86/efi/run b/x86/efi/run
>> index ac368a5..9bf0dc8 100755
>> --- a/x86/efi/run
>> +++ b/x86/efi/run
>> @@ -43,6 +43,43 @@ fi
>>  mkdir -p "$EFI_CASE_DIR"
>>  cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>>
>> +amdsev_opts=
>> +if [ -n "$AMDSEV" ]; then
>> +       # Guest policy bits, used to form QEMU command line.
>> +       readonly AMDSEV_POLICY_NODBG=$(( 1 << 0 ))
>> +       readonly AMDSEV_POLICY_ES=$(( 1 << 2 ))
>> +
>> +       gcc -x c -o getcbitpos - <<EOF
>> +       /* CPUID Fn8000_001F_EBX bits 5:0 */
>> +       int get_cbit_pos(void)
>> +       {
>> +               int ebx;
>> +               __asm__("mov \$0x8000001f , %eax\n\t");
>> +               __asm__("cpuid\n\t");
>> +               __asm__("mov %%ebx, %0\n\t":"=r" (ebx));
>> +               return (ebx & 0x3f);
>> +       }
>> +       int main(void)
>> +       {
>> +               return get_cbit_pos();
>> +       }
>> +EOF
> 
> We could do this in bash directly, using the cpuid driver:
> https://man7.org/linux/man-pages/man4/cpuid.4.html
> 
> I'm not a Linux shell wizard, but I found an example of a script using
> this module here:
> https://git.irsamc.ups-tlse.fr/dsanchez/spectre-meltdown-checker/src/branch/master/spectre-meltdown-checker.sh
> 
> After studying that script (for like an hour, lol), I was able to
> extract the cbit position. Below, I explain how to do this with the
> cpuid driver. My only complaint about using the cpuid driver is that
> it's awfully hard to follow. So I'd be OK to stick with the C code
> that you've got. Though it may be better to break out the C code into
> an actual .c file, rather than embed it in the script like this, and
> magically build it and clean it up, which seems pretty hacky. I know I
> was doing something similar with a dummy.c file embedded in the run
> script file to get the run_tests.sh script to work, and Paolo ended up
> moving that into an explicit build target in the x86/ directory.
> 
> Getting the c bit position in pure bash, using the cpuid driver.
> $ ebx=$(dd if=/dev/cpu/0/cpuid bs=16 skip=134217729 count=16
> 2>/dev/null | od -j 240 -An -t u4 | awk '{print $'"2"'}')
> $ echo $(( $ebx&0x3f ))
> 

Tom also suggested magic using the cpuid module earlier [1], but I would
like to avoid a dependency on CONFIG_X86_CPUID here. Besides the readability
of the C snippet, I believe gcc (ie userspace) is easier to install on a set
of test hosts already prepared with CONFIG_X86_CPUID=n, than to
enable/deploy/install the cpuid kmod there, which becomes important when
testing a large number of hosts at once.

Unlike x86/dummy.c, the C code doesn't run in a guest context, which is why
I'm hesitant to place it as a build target under x86/. I "hid" it within
the run script since it's only needed when constructing the qemu cmdline,
and packaging a 'getcbitpos' binary didn't make much sense. Thoughts?

[1] https://lore.kernel.org/kvm/1a79ea5b-71dd-2782-feba-0d733f8c2fbf@amd.com/

Thanks,
Varad


> Breaking it down:
> 
> # Use dd to read the 0x8000001f leaf via the cpuid driver:
> # bs=16: block size of 16 bytes; required by the driver per it's man page
> # skip=134217729: This is the CPUID leaf, 0x8000001f as a decimal number,
> #      divided by the block size
> # count=16: We actually only want to read a count=1 16 byte block
> #      because {eax, ebx, ecx, edx} is a single 16 byte block.
> However, our CPUID leaf,
> #      0x8000001f, doesn't divide evenly by 16. It has a remainder of
> 15. So read the
> #      previous 15 sixteen-byte blocks, plus the block we actually want to read.
> $ dd if=/dev/cpu/0/cpuid bs=16 skip=134217729 count=16 2>/dev/null
> 
> # Use od to convert the binary data returned by the cpuid driver into ascii.
> # -j 240: Skip the first 15 sixteen-byte blocks that we only read to
> appease the 16 byte block size. (15 * 16 = 240).
> # -An: Don't label the output with indexes.
> # -t u4: Output the data as 4-byte unsigned decimal #'s.
> od -j 240 -An -t u4
> 
> The od command above outputs the four CPUID values {eax, ebx, ecx,
> edx}. On my machine:
>       65551        367        509        100
> 
> Finally, use awk to take the second one -- ebx. And then take the
> lower 6 bits for the c-bit position.
> 
>> +
>> +       cbitpos=$(./getcbitpos ; echo $?) || rm ./getcbitpos
>> +       policy=
>> +       if [ "$AMDSEV" = "sev" ]; then
>> +               policy="$(( $AMDSEV_POLICY_NODBG ))"
>> +       elif [ "$AMDSEV" = "sev-es" ]; then
>> +               policy="$(( $AMDSEV_POLICY_NODBG | $AMDSEV_POLICY_ES ))"
>> +       else
>> +               echo "Cannot set AMDSEV policy. AMDSEV must be one of 'sev', 'sev-es'."
>> +               exit 2
>> +       fi
>> +
>> +       amdsev_opts="-object sev-guest,id=sev0,cbitpos=${cbitpos},reduced-phys-bits=1,policy=${policy} \
>> +                    -machine memory-encryption=sev0"
>> +fi
>> +
>>  # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
>>  # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
>>  # memory region is ~42MiB. Although this is sufficient for many test cases to
>> @@ -61,4 +98,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>>         -nographic \
>>         -m 256 \
>>         "$@" \
>> +       $amdsev_opts \
>>         -smp "$EFI_SMP"
>> --
>> 2.34.1
>>
> 

