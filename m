Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA857C0324
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 20:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbjJJSDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 14:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbjJJSDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 14:03:47 -0400
X-Greylist: delayed 16423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Oct 2023 11:03:41 PDT
Received: from 5.mo583.mail-out.ovh.net (5.mo583.mail-out.ovh.net [87.98.173.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B2A94
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 11:03:41 -0700 (PDT)
Received: from director2.ghost.mail-out.ovh.net (unknown [10.109.146.143])
        by mo583.mail-out.ovh.net (Postfix) with ESMTP id A354E2838D
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 18:03:39 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-rfnfq (unknown [10.110.103.92])
        by director2.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 26EE71FE7B;
        Tue, 10 Oct 2023 18:03:39 +0000 (UTC)
Received: from RCM-web2.webmail.mail.ovh.net ([176.31.232.109])
        by ghost-submission-6684bf9d7b-rfnfq with ESMTPSA
        id GIhHCPuRJWW7fgAACGw8uA
        (envelope-from <jose.pekkarinen@foxhound.fi>); Tue, 10 Oct 2023 18:03:39 +0000
MIME-Version: 1.0
Date:   Tue, 10 Oct 2023 21:03:38 +0300
From:   =?UTF-8?Q?Jos=C3=A9_Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To:     Peter Gonda <pgonda@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, skhan@linuxfoundation.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] kvm/sev: make SEV/SEV-ES asids configurable
In-Reply-To: <CAMkAt6o7urak_kAjxEU4wtXv-mGOnyOYdcyhCRMfAG3MAOip0g@mail.gmail.com>
References: <20231010100441.30950-1-jose.pekkarinen@foxhound.fi>
 <CAMkAt6o7urak_kAjxEU4wtXv-mGOnyOYdcyhCRMfAG3MAOip0g@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8fd78d002d84f3164eb5a9337e694fa1@foxhound.fi>
X-Sender: jose.pekkarinen@foxhound.fi
Organization: Foxhound Ltd.
X-Originating-IP: 23.128.248.14
X-Webmail-UserID: jose.pekkarinen@foxhound.fi
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10519001355388888742
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrheehgdduudekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepggffhffvvefujghffgfkgihoihgtgfesthekjhdttderjeenucfhrhhomheplfhoshorucfrvghkkhgrrhhinhgvnhcuoehjohhsvgdrphgvkhhkrghrihhnvghnsehfohighhhouhhnugdrfhhiqeenucggtffrrghtthgvrhhnpeekhfeguddufeegvdelgedtvdffgeehvddtkeevkeejvedvgeeitdefleehtdeitdenucfkphepuddvjedrtddrtddruddpvdefrdduvdekrddvgeekrddugedpudejiedrfedurddvfedvrddutdelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheekfedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-10-10 19:49, Peter Gonda wrote:
> On Tue, Oct 10, 2023 at 5:22 AM José Pekkarinen
> <jose.pekkarinen@foxhound.fi> wrote:
>> 
>> There are bioses that doesn't allow to configure the
>> number of asids allocated for SEV/SEV-ES, for those
>> cases, the default behaviour allocates all the asids
>> for SEV, leaving no room for SEV-ES to have some fun.
>> If the user request SEV-ES to be enabled, it will
>> find the kernel just run out of resources and ignored
>> user request. This following patch will address this
>> issue by making the number of asids for SEV/SEV-ES
>> configurable over kernel module parameters.
>> 
> 
> All this patch does is introduce an error case right? Because if the
> BIOS hasn't actually configured those SEV-ES asids and KVM tries to
> use an SEV as an SEV-ES asid commands to the ASP will fail, right?
> 
> What happens when you try to create an SEV-ES VM with this patch, when
> the BIOS hasn't allocated any SEV-ES asids?

     It still doesn't enable SEV-ES since the cpu exposes
min_sev_asids as 1, and there is a check to bail out in
the hardware setup function, so definitely this is not
fixing anything. I may not being understanding something
here though, since my BIOS doesn't seem to have any options
nor hints about SEV-ES, so I'm not quite sure it really
does something to provide the functionality. For the records
it is a Supermicro H11SSL-NC.

     Thanks!

     José.
