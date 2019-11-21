Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F31104E9C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 09:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKUI6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 03:58:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33436 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfKUI6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 03:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574326715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=5vo5aImJRI04ytV5bzibQHrtCMLtHTe5h3BdE00xi7Q=;
        b=cB93XGUcTmGFllZkAE90aleyrXr7MHH+DtjMzbJ5d0CZWJhToQ+VZdLJCpF+o7sLwAHcyl
        JPlabZVYGTzn9vuQpbzdrzO5qd+1zizwQ53cIGouKKt6VX2SWKrv92cQotir0wC+P/cy+9
        fZOfK1+0m7E7MSaoUZnj5BvpfoMMomM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-pClfLYBtPZWJj0mCi7ALig-1; Thu, 21 Nov 2019 03:58:27 -0500
Received: by mail-wr1-f71.google.com with SMTP id c12so426163wrq.7
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 00:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sCmKx0alGdWS1edtMABKHywlxEIqQr0SHiAwqlNmhiI=;
        b=r6ptUmsqPWsbgSh3etyZ+Vvz+pF9AWqRRNgxsSNXZhsJrWt748XxVFHQMCwxn7Uwdl
         ACUlJ63HmdbHGYIO58IJv5xS49T/SE/EUgLsQcn/eNLo9RQ8iffnQOjGxNpZxS11hKBU
         5zsCN74KREBbsNQUTbsh3NHPa4WWb4hZGvpTBVDobpZLOSvNyTFQNwmglKLh7qwWnrma
         ne+BYRB29kZdirXC/cZlp51eby67jtAM3MohYf4Q7ad5pG/w6ZHlEL2tqBnCGC7CDHQQ
         XluoEDyIAGw1YxB6VQKuBJTlszwX2alAsVLTXusZDDzlRDfmVVqYv1dX5om0+0+jbQD1
         4rZQ==
X-Gm-Message-State: APjAAAVsvYp26ptrCwiacfN5BarKvqM1XRqbucWyMtz+SZiMRZZtbnzI
        T5h93mL0CB8YDa6HtfqzuLiSjOcX4+3cCX7Og6G4KQHHB1VNrL4g2FOOUzrvD0u2rVz31iYiqcJ
        jRkXDXSYkXBU0
X-Received: by 2002:adf:f108:: with SMTP id r8mr301739wro.390.1574326706544;
        Thu, 21 Nov 2019 00:58:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzhpPUBrdJMs3GDqJXStN+Ui3qdExeHo3qQr+2CCFWqDTetXUpI0bjUjmWgLMo+sRzmAIhrw==
X-Received: by 2002:adf:f108:: with SMTP id r8mr301721wro.390.1574326706249;
        Thu, 21 Nov 2019 00:58:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id r25sm2130012wmh.6.2019.11.21.00.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 00:58:25 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm updates for 5.5
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20191120164236.29359-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3cde0da8-62a5-d1a5-b6b9-58baf890707a@redhat.com>
Date:   Thu, 21 Nov 2019 09:58:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
Content-Language: en-US
X-MC-Unique: pClfLYBtPZWJj0mCi7ALig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 17:42, Marc Zyngier wrote:
> Paolo, Radim,
>=20
> Here's the bulk of KVM/arm updates for 5.5. On the menu, two new features=
:
> - Stolen time is finally exposed to guests. Yay!
> - We can report (and potentially emulate) instructions that KVM cannot
>   handle in kernel space to userspace. Yay again!
>=20
> Apart from that, a fairly mundane bag of perf optimization, cleanup and
> bug fixes.
>=20
> Note that this series is based on a shared branch with the arm64 tree,
> avoiding a potential delicate merge.
>=20
> Please pull,

Pulled, thanks.  Note that the new capabilities had a conflict and were
bumped by one.

Paolo

