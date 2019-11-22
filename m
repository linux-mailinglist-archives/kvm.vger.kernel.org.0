Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E0110781E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 20:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKVTmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 14:42:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49526 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727130AbfKVTmM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Nov 2019 14:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574451731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ca8EqBdn9A1B3zQzjwlr8aMiGS5urRsu6DvfrAUI+TU=;
        b=fP/UZpBpSAFjT27RYqPxWLA3U5hDjA5/uHGKIGwQxgARH/XcZ3Wmo4CTtlYuKn3icz1cQk
        tsV/LbmviFFkNnQgCNlyqIq12p/mz5kHXK++FMiLsrqqjXaEfk4NBvaXVy6ayuATMIsuS7
        iosVhKRC232DoOnUUiRItgO/iAYEvDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-uCy1lTQ8O1S7jN9x-CoYSA-1; Fri, 22 Nov 2019 14:42:09 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10BB81083E83
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 19:42:09 +0000 (UTC)
Received: from amt.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAB0460925;
        Fri, 22 Nov 2019 19:42:06 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 9492C1004D1;
        Fri, 22 Nov 2019 17:41:52 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id xAMJfmZ2022627;
        Fri, 22 Nov 2019 17:41:48 -0200
Date:   Fri, 22 Nov 2019 17:41:48 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests Patch v1 0/2] x86: Test IOAPIC physical and
 logical destination mode
Message-ID: <20191122194145.GB22316@amt.cnet>
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: uCy1lTQ8O1S7jN9x-CoYSA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 07:47:07AM -0500, Nitesh Narayan Lal wrote:
> The first patch adds smp configuration to ioapic unittest and
> the second one adds the support to test both physical and logical destina=
tion
> modes under fixed delivery mode.
>=20
> Nitesh Narayan Lal (2):
>   x86: ioapic: Add the smp configuration to ioapic unittest
>   x86: ioapic: Test physical and logical destination mode
>=20
>  x86/ioapic.c      | 65 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  x86/unittests.cfg |  1 +
>  2 files changed, 66 insertions(+)

Looks good to me.

