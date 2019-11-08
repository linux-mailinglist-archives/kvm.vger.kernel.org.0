Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64F1F5801
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387638AbfKHUBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 15:01:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60671 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729833AbfKHUBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 15:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573243268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffctAtbPXcBTBuLIiux2KaHS5fRMOIGSG7xeRH/sRtU=;
        b=YjUYWdVKof58GIRGGmb8tIu2lyS2sEYZ8Sn7mwkbf5ZcCHxFfuiHBsxsYbRMHIOjApAyGW
        MupFGOfhpiXLRV+51qzb5FX8g78wYCOSWLxpSFVuYsTl3tFKb+DgzvJa7BnW+TtFJ0AsR2
        lhrQXzmseypW/CcWX1tA9Uzo+eKDlYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-DcqyWUrLNZu7yMhqcdDBxw-1; Fri, 08 Nov 2019 15:01:06 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D6AE1800DFB;
        Fri,  8 Nov 2019 20:01:05 +0000 (UTC)
Received: from mail (ovpn-125-151.rdu2.redhat.com [10.10.125.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0D5560C18;
        Fri,  8 Nov 2019 20:01:04 +0000 (UTC)
Date:   Fri, 8 Nov 2019 15:01:03 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
Message-ID: <20191108200103.GA532@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com>
 <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
 <20191108135631.GA22507@linux-8ccs>
 <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
MIME-Version: 1.0
In-Reply-To: <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: DcqyWUrLNZu7yMhqcdDBxw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 08, 2019 at 08:51:04PM +0100, Paolo Bonzini wrote:
> I suppose we could use code patching mechanism to avoid the retpolines.
>  Andrea, what do you think about that?  That would have the advantage
> that we won't have to remove kvm_x86_ops. :)

page 17 covers pvops:

https://people.redhat.com/~aarcange/slides/2019-KVM-monolithic.pdf

