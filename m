Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6515FA168
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJJPvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 11:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJJPvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 11:51:48 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9321427B33
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:51:47 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 78so10557846pgb.13
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hIt0t1xcXdrtBGcH8SAZ/36EkM9pDcb6p9X18pwFo3A=;
        b=nPSFYCtPHQwzrIic0FPQoSaiXMf/bqEr+NIF9QG34YGpgv0Y/MkS7bsAmcURO1Z4BE
         DCUiUMp3qTAkwWXkPKIaVUtRC1JoiuPwNg21Uy0q1twp6+aPp11h/xKp2R3mRSxIZzEh
         Z8NQwFvt64PbTvohDHURJfr5HRCaXQnwH3vCpG6c0X+HWys41Kuh6hXzfk5Fpy0EE7YG
         YwROL7ySnn92VooL+YnOK79UBnvIndBHDx+uITAVMqAsmRTw/k0CxRMexXIy+tnJhoar
         LS7z3EZ38X2nngpxzRYiNLg/trCtN2Afzvg4N8SJsVwXlDn+iRrc5L1ZEkoY43HtVA3u
         Y8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hIt0t1xcXdrtBGcH8SAZ/36EkM9pDcb6p9X18pwFo3A=;
        b=jayvToShKBYpsLmnjsWTRJfrypjJw27X9aJmBd2Hd9evOmVgueibifGOFcstIm0YMt
         mjkA2+ERQYZUbmVEvHh8zX9539thIQP9VpTfKhe/6GPDm/8HkIvXcufAAYzCdLrKA0Xx
         rONOMVNBFIWtixltLBCZhUNAekis+Hzx6t+9GxtAwQFJVDj7odWpbMzAiEXEBl1Nwoii
         X4/yxrsywWmzVLefPOZQuBFkUwx7emAoQzDhijXL/vZYtRbWY60r68+scoueBY7Zeqjh
         xsok71uaSkEwODHEktQ+Wk07jv3HL4L0VUpG6vL4lmgQ7EjeSrhW9XsjlZ3AWE0EyVju
         KIAA==
X-Gm-Message-State: ACrzQf3Qlqz1fTuBBvWwBVaoprs+KF4a7iOhViDQNLSB7lOMETIWDPJl
        MEU58PLVpeE0N+WjgmUZojwuUw==
X-Google-Smtp-Source: AMsMyM6QwCJ6EiilWWvDV3nia1JeXo3WAhNWv6TW4Xy+6W2XVrrSm9f3cIQ//TqNRuEgS79t1cRz0g==
X-Received: by 2002:a63:b5d:0:b0:45f:d7d0:5808 with SMTP id a29-20020a630b5d000000b0045fd7d05808mr12144049pgl.330.1665417106626;
        Mon, 10 Oct 2022 08:51:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d19-20020a170903209300b00173411a4385sm6788953plc.43.2022.10.10.08.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 08:51:45 -0700 (PDT)
Date:   Mon, 10 Oct 2022 15:51:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
Subject: Re: [PATCHv4 0/8] Virtual NMI feature
Message-ID: <Y0Q/jVzFz3MoP26d@google.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
 <Yz8hIY9XdlycXE+N@google.com>
 <b8a6ac33-eb39-5bf3-db55-a2189d67d202@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8a6ac33-eb39-5bf3-db55-a2189d67d202@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022, Santosh Shukla wrote:
> 
> 
> On 10/7/2022 12:10 AM, Sean Christopherson wrote:
> > On Mon, Aug 29, 2022, Santosh Shukla wrote:
> >> If NMI virtualization enabled and NMI_INTERCEPT bit is unset
> >> then HW will exit with #INVALID exit reason.
> >>
> >> To enable the VNMI capability, Hypervisor need to program
> >> V_NMI_ENABLE bit 1.
> >>
> >> The presence of this feature is indicated via the CPUID function
> >> 0x8000000A_EDX[25].
> > 
> > Until there is publicly available documentation, I am not going to review this
> > any further.  This goes for all new features, e.g. PerfMonv2[*].  I understand
> > the need and desire to get code merged far in advance of hardware being available,
> > but y'all clearly have specs, i.e. this is a very solvable problem.  Throw all the
> > disclaimers you want on the specs to make it abundantly clear that they are for
> > preview purposes or whatever, but reviewing KVM code without a spec just doesn't
> > work for me.
> > 
> 
> Sure Sean.
> 
> I am told that the APM should be out in the next couple of weeks.

Probably too late to be of much value for virtual NMI support, but for future
features, it would be very helpful to release "preview" documentation ASAP so that
we don't have to wait for the next APM update, which IIUC only happens ~2 times a
year.
