Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9397D11352C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 19:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfLDSsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 13:48:52 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbfLDSsu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 13:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575485329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n4AOyFS7+D4FhhTpdjL37PUMrrBBkYmpN5co4ha1RY8=;
        b=Vm85zB5Oq9w15/TGpHb/TtVIqBmayklxCXHXlHMvkluGGsmZDT7z+oMNW07yR6QgBqaumf
        8S87QczoaBebRrha5mbcjXIJvvpjJEQdyVjWtSv+hWKnQ/M6j/VOLaRw5hLm0OA3R+NJg0
        Zxi9CJDjS8av1G/iPhOal1Y+TV/gaxU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-MujNej50Ogat67Mn2aTeog-1; Wed, 04 Dec 2019 13:48:46 -0500
Received: by mail-qt1-f198.google.com with SMTP id a20so598154qtp.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 10:48:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yMp6tLzNoP1+pwDQEtsvP5wdwSsl9VcVUyq5Q7+GZQ0=;
        b=rLBPS3f2iEvnAKQpTjFmKS9ldWhIKi5MbcYNjN8ZMMfmz+5HLWVFbrjp1S6VM6R9zr
         k7hIv/GgTPtbYnON9VbOdu4HdeTfFf1Y05exWucaB00hLvCE3BFD3PT1l2qg30JZCd2/
         XwWiTSu8Bx4po1hZyylSsWtB1fR3xi/A1koIjig8YUbj+Ii4fKCEX4OBIukaanJwRNzP
         MSB6Qq2IUzocT2PvRhuz872pIclRmdLTea4htKUeSKsoo7ueZ2Or7ucKgiU2ZZpkroFC
         l7Gw6GKVBYdJqtAcPXEXHafkoVOqevg4hwUc0EXqmJFSj+coMxX8prh8f3WbIN//H1gb
         7snA==
X-Gm-Message-State: APjAAAViEtFtXr82dvihdMJFGQlkbbYgjJLUqpv0Lfp2jqtF6D9Ica44
        J/CQb15K7Je3fNh1WFfG06sNCnovVFUXC8vxA5lcS/HhwrNmw5hpAjYHOAionn3xidLHTuIE/eK
        y4xdJACAVYPrz
X-Received: by 2002:a05:620a:2094:: with SMTP id e20mr3944843qka.415.1575485326172;
        Wed, 04 Dec 2019 10:48:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqwiJyJa8neSnXDhV+jOnH/y9B9gMOIPLiIEQnc6q9WbiSvu9A5l5lpBJ7/5aZLvRVtDkzOfTw==
X-Received: by 2002:a05:620a:2094:: with SMTP id e20mr3944817qka.415.1575485325874;
        Wed, 04 Dec 2019 10:48:45 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id 3sm4193045qth.2.2019.12.04.10.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:48:45 -0800 (PST)
Date:   Wed, 4 Dec 2019 13:48:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: X86: Use APIC_DEST_* macros properly in
 kvm_lapic_irq.dest_mode
Message-ID: <20191204184844.GA19939@xz-x1>
References: <20191203165903.22917-1-peterx@redhat.com>
 <20191203165903.22917-4-peterx@redhat.com>
 <20191203220752.GJ19877@linux.intel.com>
 <20191203221519.GI17275@xz-x1>
 <20191203222036.GL19877@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191203222036.GL19877@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: MujNej50Ogat67Mn2aTeog-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 02:20:36PM -0800, Sean Christopherson wrote:
> On Tue, Dec 03, 2019 at 05:15:19PM -0500, Peter Xu wrote:
> > On Tue, Dec 03, 2019 at 02:07:52PM -0800, Sean Christopherson wrote:
> > > On Tue, Dec 03, 2019 at 11:59:00AM -0500, Peter Xu wrote:
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm=
/kvm_host.h
> > > > index b79cd6aa4075..f815c97b1b57 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1022,6 +1022,11 @@ struct kvm_lapic_irq {
> > > >  =09bool msi_redir_hint;
> > > >  };
> > > > =20
> > > > +static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode)
> > > > +{
> > > > +=09return dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
> > >=20
> > > IMO this belongs in ioapic.c as it's specifically provided for conver=
ting
> > > an I/O APIC redirection entry into a local APIC destination mode.  Wi=
thout
> > > the I/O APIC context, %true=3D=3DAPIC_DEST_LOGICAL looks like a compl=
etely
> > > arbitrary decision.  And if it's in ioapic.c, it can take the union
> > > of a bool, which avoids the casting and shortens the callers.  E.g.:
> > >=20
> > > static u64 ioapic_to_lapic_dest_mode(union kvm_ioapic_redirect_entry =
*e)
> > > {
> > > =09return e->fields.dest_mode ?  APIC_DEST_LOGICAL : APIC_DEST_PHYSIC=
AL;
> > > }
> > >=20
> > > The other option would be to use the same approach as delivery_mode a=
nd
> > > open code the shift.
> >=20
> > It's also used for MSI address encodings, please see below [1].
>=20
> Boooh.  How about naming the param "logical_dest_mode" or something else
> with "logical" in the name so that the correctness of the function itself
> is apparent?

Ok, will do.  Thanks,

--=20
Peter Xu

