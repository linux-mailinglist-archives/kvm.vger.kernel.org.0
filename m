Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6897211020E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfLCQV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:21:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30551 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726330AbfLCQV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575390114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Krr7ZwxuAitCp24WVDOUedZ/Q7sKuIWyB1AA5BQo0EE=;
        b=CEiif7REF8Jdkd01GtXjckLFYb4nGlJYUKfLpTNo/HTGRmpE+mbRWEmRR7KxyMHV8JJ/Yi
        UjeLai2apC9QpyFQeALr4jqVhWr7At2VJTu+vRQIysukN7UQvwEqvHajWzmiaLTe3qOvGs
        E/suagMOmzMHizjKyiYcWnKp9jDLjW8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-Ut8GS0nAPgqsTfCF70JhBQ-1; Tue, 03 Dec 2019 11:21:53 -0500
Received: by mail-qt1-f197.google.com with SMTP id l4so2761183qte.18
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:21:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QBbNGfvUlTYS0yIz8xLqE+mI2O2biBkly1Uwosv+Za8=;
        b=KsmhU9XYlAf2xr24AwmB/itVv3D86oQTUL3CBaFn9xPmJson1R0QtvaIrld55rideC
         hwEJidsP88cnCjTJhAqqjA+6dDJLtSQPOM8gUwBTAkyrRUzvpqQuyyOFKNQ85i/PAnM7
         OGDMhq9t5UscaqyRWcQKBgADN6lRSlntmmyTplkeUsA6Sih9mp9P36PW+X1qXLhOfDg3
         wqpqWWdhv+KJd7cCKo91CVIpPtAtFWyZCF/piSt09GI5tC6McTJITR3OFvlRbWh+NE7t
         2AlDuSOAkhDB0c2N9dBhVbyWimqmXArnXUrBplrAt41SD8Zkno9TZmfUQUiz+GujQD/o
         Zegg==
X-Gm-Message-State: APjAAAWPPDvdF3PyL/uQaZCabtANjeTgifHWHiEATA64DyUSDXWhLdhl
        QdWoHAQ/w1XtdunVbas2fJZRE1zq6ZyPPYJHtnJrGltC07lpy+JqI758ulVP3Q7h8CU03gD9IQn
        0VkHVwl4bubS9
X-Received: by 2002:a05:620a:113a:: with SMTP id p26mr5917405qkk.491.1575390112972;
        Tue, 03 Dec 2019 08:21:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+ctfQIoW78w8OdbCo+kvI8ncqL4KHBecGiT6GAly/K7HMAi0YO7NohD2Vyk8qsxsJQy1OLQ==
X-Received: by 2002:a05:620a:113a:: with SMTP id p26mr5917372qkk.491.1575390112700;
        Tue, 03 Dec 2019 08:21:52 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h203sm2024678qke.90.2019.12.03.08.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:21:52 -0800 (PST)
Date:   Tue, 3 Dec 2019 11:21:50 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] KVM: X86: Drop KVM_APIC_SHORT_MASK and
 KVM_APIC_DEST_MASK
Message-ID: <20191203162150.GC17275@xz-x1>
References: <20191202201314.543-1-peterx@redhat.com>
 <20191202201314.543-5-peterx@redhat.com>
 <87tv6hbl7v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
In-Reply-To: <87tv6hbl7v.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: Ut8GS0nAPgqsTfCF70JhBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 02:19:16PM +0100, Vitaly Kuznetsov wrote:
> > @@ -4519,9 +4519,9 @@ static int avic_incomplete_ipi_interception(struc=
t vcpu_svm *svm)
> >  =09=09 */
> >  =09=09kvm_for_each_vcpu(i, vcpu, kvm) {
> >  =09=09=09bool m =3D kvm_apic_match_dest(vcpu, apic,
> > -=09=09=09=09=09=09     icrl & KVM_APIC_SHORT_MASK,
> > +=09=09=09=09=09=09     icrl & APIC_SHORT_MASK,
> >  =09=09=09=09=09=09     GET_APIC_DEST_FIELD(icrh),
> > -=09=09=09=09=09=09     icrl & KVM_APIC_DEST_MASK);
> > +=09=09=09=09=09=09     icrl & APIC_DEST_MASK);
> > =20
> >  =09=09=09if (m && !avic_vcpu_is_running(vcpu))
> >  =09=09=09=09kvm_vcpu_wake_up(vcpu);
>=20
> Personal taste but I would've preserved KVM_ prefix. The patch itself
> looks correct, so

KVM apic uses apicdefs.h a lot, so I was trying to match them (APIC_*)
with it.

>=20
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for the reviews,

--=20
Peter Xu

