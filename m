Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99E932249C
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 04:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBWDXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 22:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhBWDXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 22:23:44 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DDDC061574
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 19:23:04 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t25so11530385pga.2
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 19:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cM912ElSbEnONaB2LnB0Nv6OpxFH4i0/1HVfdpaNpY8=;
        b=b4d0cm7hkKVINHwLJCwsdiOkchqjj595BNkiLzaMaLexd3IxpbCdJSaQLu6kHyFe+W
         Bfj9wd5P+BQC0k0gabkOKehVZVrSiDBCO//LMM0AHJIJ2/hdI2QfkALKZQ6WdH+u3AmV
         7iV7d4AQx0sZOZyt5NxBP34JQgjmyOkDz9RiCQ6dyLZwuijMTZp5lkHG2Ot0AbjCntCJ
         CcBZeE50uepyb1+Xs13FB5OVKxOGGJDKf1yraXA/vaTypwBAZb3NnU2ogp7mGRMCYc+x
         lEEA44k447FxFfd1LMmveMN7gzzmYDNNo3Tt+PO1835lyisSqFPumOoc4RbPz5ZjQNnt
         lk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cM912ElSbEnONaB2LnB0Nv6OpxFH4i0/1HVfdpaNpY8=;
        b=fIsHMjNoKAUVqHWtFRHLlakWC7SI+aA62BQSc3TszoqaiTh0dIyKs6iVL8enV7w3xA
         mUsP2DOLC5jFqM6D7TFLhX3P0MUdZxBNc0KWByVDylFNQG7wkZ6yoSTfG4/oeI+SRSrK
         cfl3T3eQGNPF7FngAHq8cFk2ij+AYLS5X0FqdE2CFDplbNBXct1YglRzTYgN+ysE4ww1
         a5lYK8xsNSl8taOJH+y7sMH5GWq2+vn1X+KiiezkpyjrrPHW49aSE+YbsbdgTcPdYT8B
         mhVCdip9iGmAYNC9q+l9MDbjPgdpezMR0Qj9tPxNT0E6T9aPDZcn1txFSSbnnuvV0gVT
         zsNg==
X-Gm-Message-State: AOAM531KYOWNCkkTkUDRg8ds8d7qh6k2I+glEo+9iUrsqb4h+K0J33Ph
        wtKKHIzsibJVUMrKSNwqyMkrMBXzXh8=
X-Google-Smtp-Source: ABdhPJx4pbCN+FlBi6x4ZQDEoRd7U6TRRM1VjdRM15KAGRnEAwhX0I37KHAiGQ4uiPZNSD/sdFUqEg==
X-Received: by 2002:a63:66c7:: with SMTP id a190mr22422890pgc.117.1614050584040;
        Mon, 22 Feb 2021 19:23:04 -0800 (PST)
Received: from localhost ([2601:647:4600:11e1:d2fd:ba5d:619c:c25d])
        by smtp.gmail.com with ESMTPSA id c29sm12962672pgb.58.2021.02.22.19.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 19:23:03 -0800 (PST)
Date:   Mon, 22 Feb 2021 19:23:01 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Isaku Yamahata <isaku.yamahata@intel.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH 02/23] kvm: Switch KVM_CAP_READONLY_MEM to a per-VM
 ioctl()
Message-ID: <20210223032301.GA88084@private.email.ne.jp>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
 <1c93f5dabe2ef573302ff362c0c6c525bbe8af43.1613188118.git.isaku.yamahata@intel.com>
 <0f29a789-9822-3dd8-b827-e5b86b933059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f29a789-9822-3dd8-b827-e5b86b933059@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 08:56:45AM +0100,
Philippe Mathieu-Daudé <philmd@redhat.com> wrote:

> Hi Isaku,
> 
> On 2/16/21 3:12 AM, Isaku Yamahata wrote:
> > Switch to making a VM ioctl() call for KVM_CAP_READONLY_MEM, which may
> > be conditional on VM type in recent versions of KVM, e.g. when TDX is
> > supported.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  accel/kvm/kvm-all.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 47516913b7..351c25a5cb 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -2164,7 +2164,7 @@ static int kvm_init(MachineState *ms)
> >      }
> >  
> >      kvm_readonly_mem_allowed =
> > -        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
> > +        (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
> 
> Can this check with "recent KVM" be a problem with older ones?
> 
> Maybe for backward compatibility we need:
> 
>           = (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0) ||
>             (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);

Agreed. That's safer and it's difficult to check the very old version of kenel
and non-x86 arch.

Thanks,

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
