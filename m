Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02FC7C77D8
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 22:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442730AbjJLUYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 16:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442679AbjJLUYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 16:24:17 -0400
X-Greylist: delayed 13121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Oct 2023 13:24:13 PDT
Received: from 20.mo584.mail-out.ovh.net (20.mo584.mail-out.ovh.net [46.105.33.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88180CC
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 13:24:13 -0700 (PDT)
Received: from director9.ghost.mail-out.ovh.net (unknown [10.108.20.204])
        by mo584.mail-out.ovh.net (Postfix) with ESMTP id 269AF2929C
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 16:45:31 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-jv9cr (unknown [10.110.103.4])
        by director9.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 6E6861FE1E;
        Thu, 12 Oct 2023 16:45:30 +0000 (UTC)
Received: from RCM-web5.webmail.mail.ovh.net ([51.255.71.60])
        by ghost-submission-6684bf9d7b-jv9cr with ESMTPSA
        id +UL6GaoiKGWgTgEAl0SSeQ
        (envelope-from <jose.pekkarinen@foxhound.fi>); Thu, 12 Oct 2023 16:45:30 +0000
MIME-Version: 1.0
Date:   Thu, 12 Oct 2023 16:45:30 +0000
From:   =?UTF-8?Q?Jos=C3=A9_Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, skhan@linuxfoundation.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] kvm/sev: remove redundant MISC_CG_RES_SEV_ES
In-Reply-To: <9faf1a1a-af49-5f6f-9f33-6cf57f884c44@redhat.com>
References: <20231010174932.29769-1-jose.pekkarinen@foxhound.fi>
 <9faf1a1a-af49-5f6f-9f33-6cf57f884c44@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6a777c72a6dc15ad80ecbedd4c6c35d9@foxhound.fi>
X-Sender: jose.pekkarinen@foxhound.fi
Organization: Foxhound Ltd.
X-Originating-IP: 109.70.100.71
X-Webmail-UserID: jose.pekkarinen@foxhound.fi
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2497808946033305254
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedriedtgdelhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeggfffhvfevufgjfhgfkfigohhitgfgsehtkehjtddtreejnecuhfhrohhmpeflohhsrocurfgvkhhkrghrihhnvghnuceojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqnecuggftrfgrthhtvghrnhepkefhgeduudefgedvleegtddvffeghedvtdekveekjeevvdegiedtfeelhedtiedtnecukfhppeduvdejrddtrddtrddupddutdelrdejtddruddttddrjedupdehuddrvdehhedrjedurdeitdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehjohhsvgdrphgvkhhkrghrihhnvghnsehfohighhhouhhnugdrfhhiqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehkeegpdhmohguvgepshhmthhpohhuthdpughkihhmpehnohhnvg
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-10-12 13:43, Paolo Bonzini wrote:
> On 10/10/23 19:49, José Pekkarinen wrote:
>> SEV-ES is an extra encrypted state that shares common resources
>> with SEV. Using an extra CG for its purpose doesn't seem to
>> provide much value. This patch will clean up the control group
>> along with multiple checks that become redundant with it.
>> 
>> The patch will also remove a redundant logic on sev initialization
>> that produces SEV-ES to be disabled, while supported by the cpu
>> and requested by the user through the sev_es parameter.
> 
> In what sense is it shared?  The SEV ASIDs and the SEV-ES ASIDs are
> separate (and in both cases limited) resources, and therefore they
> have separate cgroups.

     Nevermind this patch, after a painful bios upgrade I got sev-es
available in it, and I was able to launch some test vm on it, so this
may only be breaking things. Sorry for the noise!

     José.
