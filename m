Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379197D05B2
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 02:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346735AbjJTAN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 20:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346738AbjJTANz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 20:13:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8C5113
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:13:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9c6f9e4d2so1734075ad.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697760832; x=1698365632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MAD0GymonKhVp5idan/hQP/ZSGOOIuiLDIayqa/R+JY=;
        b=2PECyDyB+Qu9lWhVXjvMnHhzoXxM04gb0I6EkHTVW1pwNnLi7OR9wyJ6KXhLmW9Kkf
         wAJURCMzLGerdlKzO4lbr9FcIRlXb2CHCW+Cqp5aNgAr/5WFTTb6kmDyIMnQ4iZLh30v
         KU4bnLi8GRXm4NNrq/iOeUPXwzHzGjX+FlJ1RyPedS8xBtJle4HwnXDQLzVpyiOi70SW
         3qR2rdiZRI8r/rDFF1TbgFJaAk+XU0BHxVY8IVZugQm4JVvHfLSmiz/3a6a5cRPG0rMt
         mhfb5X6vLShzc26UhwgV6FRYgsUXBAc1W8ygTicufFhc71pC20S1rnDPAdvoSVZ9V9x1
         4RDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697760832; x=1698365632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAD0GymonKhVp5idan/hQP/ZSGOOIuiLDIayqa/R+JY=;
        b=e3EAdpratv9PlIAcdaDgJ9FgyeJp/2XUVaeRAXCIvPOioe4KPzGW6UxxRRDtLq6hQ6
         mQVK7SD3XlQxCDxgX8vPW4jljF7qizyCn4eRBGtP+HrKyPy29efZvpMs+NjzmUF8fl54
         V1AA2j6lLMGCxuj75DkrmN03eBmcrL0vpsG8BW3/L70Hd/9GGwGR1CPG/VYyGi7UKF/x
         zEiuE5Gx+bpQwn3pDq0bqpnuTtYZ9z8V3Cjon5EizM7UqtUT5JJ6pki5/vD+DuKdGP4w
         ILzAj3x83Nr/sxwFsNyszWuwQkRlPj7AjXU5MToOJ/MnMqG6r/HZNlrKxbRRTlOJHesT
         nHWg==
X-Gm-Message-State: AOJu0YzcH+pggUH4POYO7DoWyCFctFaLTo2YrPylT9jZSDehE9TxEWxK
        ifVbzoXiixICOaqgKEX6a9MM0J8e0jI=
X-Google-Smtp-Source: AGHT+IFyYxrvznGGGQlvwIi5BcnD4kPqU6aMry2TjpSLSB2IZR8/8bU6BC4niY0jsoo5JMNhR/z1HTzXD5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab03:b0:1c3:4d70:6ed9 with SMTP id
 ik3-20020a170902ab0300b001c34d706ed9mr9607plb.3.1697760831964; Thu, 19 Oct
 2023 17:13:51 -0700 (PDT)
Date:   Fri, 20 Oct 2023 00:13:50 +0000
In-Reply-To: <2034624b-579f-482e-8a7a-0dfc91740d7e@amd.com>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <924b755a-977a-4476-9525-a7626d728e18@amd.com>
 <ZTFD8y5T9nPOpCyX@google.com> <2034624b-579f-482e-8a7a-0dfc91740d7e@amd.com>
Message-ID: <ZTHGPlTXvLnEDbmd@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023, Alexey Kardashevskiy wrote:
> 
> On 20/10/23 01:57, Sean Christopherson wrote:
> > On Thu, Oct 19, 2023, Alexey Kardashevskiy wrote:
> > > > 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
> > > > 	return 0;
> > > > }
> > > 
> > > This should work the KVM stored certs nicely but not for the global certs.
> > > Although I am not all convinced that global certs is all that valuable but I
> > > do not know the history of that, happened before I joined so I let others to
> > > comment on that. Thanks,
> > 
> > Aren't the global certs provided by userspace too though?  If all certs are
> > ultimately controlled by userspace, I don't see any reason to make the kernel a
> > middle-man.
> 
> The max blob size is 32KB or so and for 200 VMs it is:

Not according to include/linux/psp-sev.h:

#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */

Ugh, and I see in another patch:

  Also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow space
  for an extra certificate.

-#define SEV_FW_BLOB_MAX_SIZE   0x4000  /* 16KB */
+#define SEV_FW_BLOB_MAX_SIZE   0x5000  /* 20KB */

That's gross and just asking for ABI problems, because then there's this:

+::
+
+       struct kvm_sev_snp_set_certs {
+               __u64 certs_uaddr;
+               __u64 certs_len
+       };
+
+The certs_len field may not exceed SEV_FW_BLOB_MAX_SIZE.

> - 6.5MB, all in the userspace so swappable  vs
> - 32KB but in the kernel so not swappable.
> Sure, a box capable of running 200 VMs must have plenty of RAM but still :)

That's making quite a few assumptions.

  1) That the global cert will be 32KiB (which clearly isn't the case today).
  2) That every VM will want the global cert.
  3) That userspace can't figure out a way to share the global cert.

Even in that absolutely worst case scenario, I am not remotely convinced that it
justifies taking on the necessary complexity to manage certs in-kernel.

> Plus, GHCB now has to go via the userspace before talking to the PSP which
> was not the case so far (though I cannot think of immediate implication
> right now).

Any argument along the lines of "because that's how we've always done it" is going
to fall on deaf ears.  If there's a real performance bottleneck with kicking out
to userspace, then I'll happily work to figure out a solution.  If.
