Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F317C00B4
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjJJPuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjJJPuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:50:15 -0400
X-Greylist: delayed 13152 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Oct 2023 08:50:11 PDT
Received: from 7.mo581.mail-out.ovh.net (7.mo581.mail-out.ovh.net [46.105.43.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F4EA7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:50:11 -0700 (PDT)
Received: from director11.ghost.mail-out.ovh.net (unknown [10.108.4.132])
        by mo581.mail-out.ovh.net (Postfix) with ESMTP id 2FAF928723
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 12:01:58 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-x96xs (unknown [10.111.172.101])
        by director11.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 71EFA1FEDD;
        Tue, 10 Oct 2023 12:01:57 +0000 (UTC)
Received: from RCM-web10.webmail.mail.ovh.net ([151.80.29.18])
        by ghost-submission-6684bf9d7b-x96xs with ESMTPSA
        id PiQoGDU9JWXNqgAAoY8iwA
        (envelope-from <jose.pekkarinen@foxhound.fi>); Tue, 10 Oct 2023 12:01:57 +0000
MIME-Version: 1.0
Date:   Tue, 10 Oct 2023 15:01:56 +0300
From:   =?UTF-8?Q?Jos=C3=A9_Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     seanjc@google.com, pbonzini@redhat.com, skhan@linuxfoundation.org,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] kvm/sev: make SEV/SEV-ES asids configurable
In-Reply-To: <2023101050-scuff-overstay-9b43@gregkh>
References: <20231010100441.30950-1-jose.pekkarinen@foxhound.fi>
 <2023101050-scuff-overstay-9b43@gregkh>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <f4713760f799766717b5a4128e63e135@foxhound.fi>
X-Sender: jose.pekkarinen@foxhound.fi
Organization: Foxhound Ltd.
X-Originating-IP: 185.233.100.23
X-Webmail-UserID: jose.pekkarinen@foxhound.fi
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4410712886810617510
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrheehgdegiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeggfffhvfevufgjfhgfkfigohhitgfgsehtkehjtddtreejnecuhfhrohhmpeflohhsrocurfgvkhhkrghrihhnvghnuceojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqnecuggftrfgrthhtvghrnhepkefhgeduudefgedvleegtddvffeghedvtdekveekjeevvdegiedtfeelhedtiedtnecukfhppeduvdejrddtrddtrddupddukeehrddvfeefrddutddtrddvfedpudehuddrkedtrddvledrudeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheekuddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-10-10 14:35, Greg KH wrote:
> On Tue, Oct 10, 2023 at 01:04:39PM +0300, José Pekkarinen wrote:
>> There are bioses that doesn't allow to configure the
>> number of asids allocated for SEV/SEV-ES, for those
>> cases, the default behaviour allocates all the asids
>> for SEV, leaving no room for SEV-ES to have some fun.
> 
> "fun"?
> 
> Also, please use the full 72 columns for your changelog.
> 

     Alright.

>> If the user request SEV-ES to be enabled, it will
>> find the kernel just run out of resources and ignored
>> user request. This following patch will address this
>> issue by making the number of asids for SEV/SEV-ES
>> configurable over kernel module parameters.
>> 
>> Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
>> ---
>>  arch/x86/kvm/svm/sev.c | 28 +++++++++++++++++++++++-----
>>  1 file changed, 23 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 07756b7348ae..68a63b42d16a 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -51,9 +51,18 @@
>>  static bool sev_enabled = true;
>>  module_param_named(sev, sev_enabled, bool, 0444);
>> 
>> +/* nr of asids requested for SEV */
>> +static unsigned int requested_sev_asids;
>> +module_param_named(sev_asids, requested_sev_asids, uint, 0444);
>> +
>>  /* enable/disable SEV-ES support */
>>  static bool sev_es_enabled = true;
>>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
>> +
>> +/* nr of asids requested for SEV-ES */
>> +static unsigned int requested_sev_es_asids;
>> +module_param_named(sev_es_asids, requested_sev_asids, uint, 0444);
> 
> Why more module parameters?  Why can't this "just work" properly 
> without
> forcing a user to make manual changes?  This isn't the 1990's anymore.

     I could think of setting both cgroup caps to the maximum
number of asids and then check the code in the module to make
sure anytime a sev/sev_es asid is reserved both cgroups get
updated to reflect the remaining asids, or even better, just
use only one cgroup to keep track of them. That way the parameters
become redundant, would any of these ideas work for you? Do you,
or anybody else, have better ideas or preferences in this topic?

>> +
>>  #else
>>  #define sev_enabled false
>>  #define sev_es_enabled false
>> @@ -2194,6 +2203,11 @@ void __init sev_hardware_setup(void)
>>  	if (!max_sev_asid)
>>  		goto out;
>> 
>> +	if (requested_sev_asids + requested_sev_es_asids > max_sev_asid) {
>> +		pr_info("SEV asids requested more than available: %u ASIDs\n", 
>> max_sev_asid);
> 
> Why isn't this an error?

     Good question, I'll address it in v2.

     Thanks!

     José.
