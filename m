Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F56A98FC
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 15:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjCCOAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 09:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCCOAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 09:00:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EBE6151E;
        Fri,  3 Mar 2023 06:00:46 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D62402052E;
        Fri,  3 Mar 2023 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677852044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxV+vqRqP5FA17gWzru5WaqMedSYhLnPR0idRcduX0g=;
        b=mGmx8NKmZojc13Vh+SoX62xVgQwefRgdcp9BblO5KfAFLL6taXUCrIP1i+Q6fSjo56vaQV
        ioQvf+LNpmkhBAl3kw7hNZQTIX0WYJ9jqNKoQZGx3K2O/T5t2qIgR7sQN5OrFb11xozY+I
        ugzz2FCwcnOVP6Ydqi1Uy0UDOSh8Vjw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677852044;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxV+vqRqP5FA17gWzru5WaqMedSYhLnPR0idRcduX0g=;
        b=TLAgG9NwjxbPa5h72UbYo83Q/SnmtX0VCXL9B8AUov5zk8kSBDzwc5rtAF7zbGyc6AT+qY
        KpQFcjqya9sSrOBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 519EA1329E;
        Fri,  3 Mar 2023 14:00:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yw8/E4z9AWSfCgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 03 Mar 2023 14:00:44 +0000
Message-ID: <86906f29-9853-6e18-6e03-7b689088ed5d@suse.cz>
Date:   Fri, 3 Mar 2023 15:00:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 08/56] KVM: SEV: Rename sev_{pin,unpin}_memory
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Nikunj A Dadhania <nikunj@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-9-michael.roth@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230220183847.59159-9-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 19:37, Michael Roth wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> Rename sev_{pin|unpin}_memory to sev_memory_{get|put}_pages. Apart
> from pinning the pages, sev_pin_memory also populates the pages array
> which is used by its callers. SEV guest using restricted memfd do not
> to pin the memory but will require the pages array to be populated.

  ^need to?

> Rename the function appropriately.
> 
> No functional change intended.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

