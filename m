Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F88223DE06
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgHFRVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:21:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46965 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729346AbgHFRVF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Aug 2020 13:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0yMbsT7pcgi1iAHyYcod+CvrElFV6deSSG6mOjxpA8=;
        b=JpkurE4TQ0HhBbugzOI7UcoukIohiO+2Q5pZdlZta5wGBQh2pLUmIxq935ZGVMRDOU724r
        ucCGYCiLwevzBgTcx3OoYOAhWyEp4urAQQBfXgdMC+HUyEiw9BIFqhjKmfxoy6b4WXPCq7
        gesZp62tf4JugFPJPFt1yEBtsQy+A7I=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-pCb0s1oHOiWP8072s2Qx3w-1; Thu, 06 Aug 2020 07:39:12 -0400
X-MC-Unique: pCb0s1oHOiWP8072s2Qx3w-1
Received: by mail-ej1-f72.google.com with SMTP id gg11so7538375ejb.6
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 04:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z0yMbsT7pcgi1iAHyYcod+CvrElFV6deSSG6mOjxpA8=;
        b=Sgp2Yv23Kk5qeZvevYG0ToEJTU3RzRph7F0HSQ5wJIwGC0Cg/vnXfJrQun3pZRLKIy
         vuNMccX0cqVYFJQdpSfJ+MIkuZCAGsC0tYkJrrhh+e5q/Fdz3O88rt77FMowfTogBW7Y
         L5KexKWGurfgHjj0jmF+iRs1eUnrcqTDToh8IJVvQ6d+n5IbKJhZSE7gmwUz5jBGkdbG
         G4z4ady2UU0bS+Gb6sbazFvA4h5RaxsDkv05EocU1xqGNT3BB7j3m/6XJxT63aibqcIN
         Qr346u6olteQ7MX+frhyXdcA5Nxlzmi0a5q2DvSD7f0pUtIvBsZz/71fnSNlzeyF8Kbp
         p+dg==
X-Gm-Message-State: AOAM53130BQzSCN5aIVW5Vziy21dAkYxIzP5b6uScWTkY9AhJrHa3ADV
        DETb4vmAfKgB9ZwExSyuXKpSjL1A156joWzrc3FRRSBTL+xxnCiyEf+uCNdU5kaTLbX+mYh2FxV
        jSa8HARuvdxem
X-Received: by 2002:a50:d485:: with SMTP id s5mr3707031edi.285.1596713951112;
        Thu, 06 Aug 2020 04:39:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9gpH7Y4wZjbEShVJ7bFDHbXcr/x4vdBu+Kk8uS1Zn8NzRbVW/Adp0kk2I0m9EFJ/FFoNX6Q==
X-Received: by 2002:a50:d485:: with SMTP id s5mr3707021edi.285.1596713950936;
        Thu, 06 Aug 2020 04:39:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w7sm3521262ejb.3.2020.08.06.04.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 04:39:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
In-Reply-To: <20200806055008-mutt-send-email-mst@kernel.org>
References: <20200728143741.2718593-1-vkuznets@redhat.com> <20200805201851-mutt-send-email-mst@kernel.org> <873650p1vo.fsf@vitty.brq.redhat.com> <20200806055008-mutt-send-email-mst@kernel.org>
Date:   Thu, 06 Aug 2020 13:39:09 +0200
Message-ID: <87wo2cngv6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> About the feature bit, I am not sure why it's really needed. A single
> mmio access is cheaper than two io accesses anyway, right? So it makes
> sense for a kvm guest whether host has this feature or not.
> We need to be careful and limit to a specific QEMU implementation
> to avoid tripping up bugs, but it seems more appropriate to
> check it using pci host IDs.

Right, it's just that "running on KVM" is too coarse grained, we just
need a way to somehow distinguish between "known/good" and
"unknown/buggy" configurations.

-- 
Vitaly

