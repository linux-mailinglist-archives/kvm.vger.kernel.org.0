Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448DA8F1F2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfHORSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 13:18:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36496 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731134AbfHORSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 13:18:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id w2so1649299pfi.3;
        Thu, 15 Aug 2019 10:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O0iU9h/CgsDkbZj91TD8RQDyFQ2IpZ1Yt3QLDe5vqPg=;
        b=tjAQYIIro/DnauaXI3INnjRJ/TkqSKPI5VSGVznvGeeUcH0xKxwESp9IFecKpept4y
         +TKAvO8LFDVo2JSUms7f4AHRLykJ3aWjv//YwbFmTCtpmd1PuO44oXTGx27ZPYbp0tCG
         VHFtbXKcpvCkHkhJ7FmwnWvPHbRKal59zAKDeiIEh51J2Se0/B2fYl1qdhPdYKC+nNtC
         t+USv/D8HJg3gS+E2b1TsBmCsghRIleh5YAorwhmjPW5URMuroF8cwyorpGyHFwaQPxA
         9YlgiSCiQOgTwIpD5QzJNmHSKLV1u0SinXcon/R22PEBoOuozKKr1wutxKfgWL+EU/rE
         i42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O0iU9h/CgsDkbZj91TD8RQDyFQ2IpZ1Yt3QLDe5vqPg=;
        b=T5Fkv0tpFHdJkCOpmCZ78/6wCSoAsPtmrpQKqGUYjAiTgiN01Q696Opanv6K0kZbjp
         wiwDijmkmx72DDK4TJTFmSptsyzkuJGTZbyjccob/347YdySBVSnnNTs4lScY7PHeqz+
         kYX95MfYrkOwF29MuXIpyjpWgYr4IeF1Boj955fW+y+c2J9II2CvcDUGWm2M5JUPUJSc
         8fzN9ibumj664GhaIFYUtElXzu4BbIw59S+hFL65sm6CEy/Zm6idvthRzamCJ5+526sW
         afmRgTr3B/6FtryKFVNX6GkI3h7ogW14jjJyLGKPrrbcPM7PumYzA1xlfPWdqA4gZviO
         fGFw==
X-Gm-Message-State: APjAAAWpxTQU13exDpQBa62DzSTwEC7roJ+op0+1zI9MxFxszHP/wCL3
        tkiSbwqyQJvOF+yEke9jX+c=
X-Google-Smtp-Source: APXvYqy7W7kXMKmt5qV1vz6zH8QBZDpT0zmtLNiJOWrKRdx4CqeHfrqqlOkAd7IoFjwEYuU4TVZlEA==
X-Received: by 2002:aa7:8f2e:: with SMTP id y14mr6509394pfr.113.1565889522309;
        Thu, 15 Aug 2019 10:18:42 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id d129sm3343983pfc.168.2019.08.15.10.18.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 10:18:41 -0700 (PDT)
Date:   Thu, 15 Aug 2019 22:48:35 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        khalid.aziz@oracle.com
Subject: Re: [Question-kvm] Can hva_to_pfn_fast be executed in interrupt
 context?
Message-ID: <20190815171834.GA14342@bharath12345-Inspiron-5559>
References: <20190813191435.GB10228@bharath12345-Inspiron-5559>
 <54182261-88a4-9970-1c3c-8402e130dcda@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54182261-88a4-9970-1c3c-8402e130dcda@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 10:17:09PM +0200, Paolo Bonzini wrote:
> On 13/08/19 21:14, Bharath Vedartham wrote:
> > Hi all,
> > 
> > I was looking at the function hva_to_pfn_fast(in virt/kvm/kvm_main) which is 
> > executed in an atomic context(even in non-atomic context, since
> > hva_to_pfn_fast is much faster than hva_to_pfn_slow).
> > 
> > My question is can this be executed in an interrupt context? 
> 
> No, it cannot for the reason you mention below.
> 
> Paolo
hmm.. Well I expected the answer to be kvm specific. 
Because I observed a similar use-case for a driver (sgi-gru) where 
we want to retrive the physical address of a virtual address. This was
done in atomic and non-atomic context similar to hva_to_pfn_fast and
hva_to_pfn_slow. __get_user_pages_fast(for atomic case) 
would not work as the driver could execute in interrupt context.

The driver manually walked the page tables to handle this issue.

Since kvm is a widely used piece of code, I asked this question to know
how kvm handled this issue. 

Thank you for your time.

Thank you
Bharath
> > The motivation for this question is that in an interrupt context, we cannot
> > assume "current" to be the task_struct of the process of interest.
> > __get_user_pages_fast assume current->mm when walking the process page
> > tables. 
> > 
> > So if this function hva_to_pfn_fast can be executed in an
> > interrupt context, it would not be safe to retrive the pfn with
> > __get_user_pages_fast. 
> > 
> > Thoughts on this?
> > 
> > Thank you
> > Bharath
> > 
> 
