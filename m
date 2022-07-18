Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F866577EDB
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiGRJnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 05:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbiGRJnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 05:43:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 244EE1AD8E
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 02:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658137379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uXsawOufScCM/h/0STmUHv9PQWBiZyHK6GMTOKvjTFs=;
        b=EWo5fFvSdhcEdOWTlvMQ+lTGgVAD1hR1O8VeDpBuy1GngC+9AYjIEOKK3yjZQJTvKRTdXm
        LjEz7ByiAL++GPGavzBYwGnEEOdjuYS3OXXcxGwLietedrvDOfYfEK2LQXr7BzeR5ryr8N
        jFaiV/JmtOX0Mew9HSjLPAY3dMnmrCw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-Z6YqmkyqONOwKmv5kRHsUQ-1; Mon, 18 Jul 2022 05:42:57 -0400
X-MC-Unique: Z6YqmkyqONOwKmv5kRHsUQ-1
Received: by mail-qk1-f197.google.com with SMTP id l189-20020a37bbc6000000b006af2596c5e8so9085817qkf.14
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 02:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uXsawOufScCM/h/0STmUHv9PQWBiZyHK6GMTOKvjTFs=;
        b=5SjH2uimv7x0NbPpLZ2C6a4w9Y2yH1eDZTg37EEImg9IhMAzF4iAS5nLeCI87oEY9H
         qolH7/+zX4z2WHg9Q9C7Gh1PlGPdfxez62GQaliCMDYFVafiJUyrjlpHVu79O2ToQUSq
         lAjxtRY099GFlrrQzWO/lSheEhOus9w8JZyvC6NAOzKhAcglkjqcfcKEqfkuqqS3W0hn
         yI62RGH5Vpklg3VRqUfkOSV/2DFQ/23VTAl3GKvAR3aqqwS/VRIvPehq9Aue8H4eIY4n
         +4ofn6OPESFgYTOxRnzSODmn3bnFlIdhrtl5YewngN+jA52FBsF1Ho5ua84MJh31WOO2
         jNEw==
X-Gm-Message-State: AJIora/LVAX9KKoWKRePFZiBlXAS4iNRowabtVWnuiLStsqP25fu+Vjr
        F77rd0wHodNZ/jnt/yYDvN7G2KS32U7rHhA4rJ+Xm8y11TV/6j+VDLrxVt16RukCELrbA6OaUE3
        Mh3zmJiTZfCHw
X-Received: by 2002:a0c:e151:0:b0:472:ed70:5f8 with SMTP id c17-20020a0ce151000000b00472ed7005f8mr19933380qvl.99.1658137377286;
        Mon, 18 Jul 2022 02:42:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sxVWRgOCtS+n9Y8O3vdTv9h5Ggs4r1AGyAzDVkKxjpFYANErewut5frVji6Q1WuW63r0aXfA==
X-Received: by 2002:a0c:e151:0:b0:472:ed70:5f8 with SMTP id c17-20020a0ce151000000b00472ed7005f8mr19933370qvl.99.1658137377073;
        Mon, 18 Jul 2022 02:42:57 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bt14-20020ac8690e000000b0031ef0081d77sm1837434qtb.79.2022.07.18.02.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 02:42:56 -0700 (PDT)
Message-ID: <298d3c2601b13bf45044e92af02a28d5440e944f.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: Reject loading KVM if host.PAT[0] != WB
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 18 Jul 2022 12:42:52 +0300
In-Reply-To: <YtH1q3C4F+LAEDTf@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
         <20220715230016.3762909-2-seanjc@google.com>
         <CALMp9eQdzZK4ZAyQZXUWff_zuRRdr=ugkujWfFrt9dP8uFcs=Q@mail.gmail.com>
         <YtH1q3C4F+LAEDTf@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 23:18 +0000, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Jim Mattson wrote:
> > On Fri, Jul 15, 2022 at 4:02 PM Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > Reject KVM if entry '0' in the host's IA32_PAT MSR is not programmed to
> > > writeback (WB) memtype.  KVM subtly relies on IA32_PAT entry '0' to be
> > > programmed to WB by leaving the PAT bits in shadow paging and NPT SPTEs
> > > as '0'.  If something other than WB is in PAT[0], at _best_ guests will
> > > suffer very poor performance, and at worst KVM will crash the system by
> > > breaking cache-coherency expecations (e.g. using WC for guest memory).
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > What if someone changes the host's PAT to violate this rule *after*
> > kvm is loaded?
> 
> Then KVM (and probably many other things in the kernel) is hosed.  The same argument
> (that KVM isn't paranoid enough) can likely be made for a number of MSRs and critical
> registers.
> 

I was thinking about the same thing and I also 100% agree with the above.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

