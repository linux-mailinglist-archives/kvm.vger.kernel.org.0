Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7948117E460
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 17:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCIQNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 12:13:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42967 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727064AbgCIQNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 12:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583770386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W1XHwLHrebu9LMIhwqNTOnWOs9BFZXV9k1ZPlF9O3rA=;
        b=bwKc8JHacSZjd+r/FDWrvWtGsXGBJ+qv5MKxSDiUwhDZBtrbKcusTt1mQSt3rejzKYKy3q
        Ejg90ZTTGP+fFmUTHDDaE72T8QTBCFklTeZAJm0XAM8LgUp4XlWWoWRi4gLJ0RZEylxyqc
        RA/hyirhT0y6mwGYd9xNNvLh/phgTF0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-RCL6P4b_MPaVMQVvEGU9rQ-1; Mon, 09 Mar 2020 12:13:04 -0400
X-MC-Unique: RCL6P4b_MPaVMQVvEGU9rQ-1
Received: by mail-wr1-f72.google.com with SMTP id u18so5384797wrn.11
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 09:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=W1XHwLHrebu9LMIhwqNTOnWOs9BFZXV9k1ZPlF9O3rA=;
        b=DJaIGR2RhOoypIcZWhJRHqu30nG/8ah3etoJkR3VdClVyZkhetGU4UldNb2creW9Z0
         ZSx/GcABrW11R+hgjqY13I57TMRDT468vjDeT5mIeGCGSlHj/XHO4XkTeL2BcVzVe6Gm
         v9GHxnrPRKALCI4wlBDjxF6BXwzobqHtCG5pORwU/jb/mIZvyP/yBUaYQQIttkDiPqH7
         ubrmNn6/pUWIH2ZuB5qOj1hRp2T1mUMaamj0FKDpmCnq9R4NGJHa2F+PrUfo8ZujkHDz
         1v1HAVCdWCQlJ5iRFDgutTHQ/NuBLo6SpmKe1/7AXk/9Ta0mRRzkox1uD5+1c0Bi7WM3
         U3Hg==
X-Gm-Message-State: ANhLgQ0A4T9lybSMATnULyWQOuVsELrtQ8Yb2C7e5FOZzzaKyCEpATRD
        OtNd+kNLr5VilaQh3kQzQuBUeG6iaTfysaJp9iyv1MpbOEGli0M1ELTo2EWFrrmdhGgVQo3ajKd
        ehMaji6sgcvOo
X-Received: by 2002:a7b:cd13:: with SMTP id f19mr87154wmj.10.1583770383161;
        Mon, 09 Mar 2020 09:13:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvS82MLks9oPpAsXh9V/muOYmPMIscmCdAMw7fzDZiOQBNRum9gnPaObrJI9WXESNdquYplXw==
X-Received: by 2002:a7b:cd13:: with SMTP id f19mr87140wmj.10.1583770382917;
        Mon, 09 Mar 2020 09:13:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q2sm2723850wrv.65.2020.03.09.09.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:13:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
In-Reply-To: <20200306163909.1020369-2-arilou@gmail.com>
References: <20200306163909.1020369-1-arilou@gmail.com> <20200306163909.1020369-2-arilou@gmail.com>
Date:   Mon, 09 Mar 2020 17:13:01 +0100
Message-ID: <87k13tcxrm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..24b7c48ccc6f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -197,6 +197,7 @@ struct kvm_hyperv_exit {
>  			__u64 msg_page;
>  		} synic;
>  		struct {
> +			__u32 pad;
>  			__u64 input;
>  			__u64 result;
>  			__u64 params[2];

This doesn't seem to be correct, __u64 get aligned at 8 byte boundary so
implicitly you now (pre-patch) have the following:

struct kvm_hyperv_exit {
	__u32 type;
        __u32 pad1;
	union {
		struct {
			__u32 msr;
                        __u32 pad2;
			__u64 control;
			__u64 evt_page;
			__u64 msg_page;
		} synic;
		struct {
			__u64 input;
			__u64 result;
			__u64 params[2];
		} hcall;
	} u;
};

and the suggestion is only to make it explicit. Adding something before
'input' will actually break ABI.

-- 
Vitaly

