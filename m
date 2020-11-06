Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DD52A9BF8
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgKFSYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 13:24:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgKFSYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 13:24:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604687060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rpoIMYpAsT/EApk0aLEONLPpU9cBzDM2egfJxA+5bKs=;
        b=AbCY9QtufGkjoqYAHaAoAeQdAk+3NjWFa1+doGEQCmxnPy5vV11iZ5Bpjt10URtTqHJR/c
        17rk1/59g38i3M4KOIJ4XrxkTK2hiwoCctoDkiNdQKeWdaq04jVdNE7C28+xlCfIkgoRAK
        VqD82D0B92zurPPdgNgrqGa8FZYq9GA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287--4aUnzR-NWejzIpd6rZxSA-1; Fri, 06 Nov 2020 13:24:19 -0500
X-MC-Unique: -4aUnzR-NWejzIpd6rZxSA-1
Received: by mail-qv1-f71.google.com with SMTP id a1so1172336qvv.18
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 10:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpoIMYpAsT/EApk0aLEONLPpU9cBzDM2egfJxA+5bKs=;
        b=fw2stzoRQmuwIDwUbdmF/xqh2Hpw62FGrsI1RpZPfDUT9NjS8Zzh9i4wsI4EKVTIJ2
         1z3gwzF1c7uJzmz/F8Mj1B1ZWtt00H85+UhjtM+D2YwqpqygQcOZRuFhQE1OymEzF3wY
         sE3+xfQOE3UkFfc7lMgl32BlRaLecJrodVQz01mDpqxrUNr/c2ICscbnZTBrhpPgHOSo
         11gSDNggqtu2B2/fJYLdhrmEGDlrnAAzFjWChQkQm5mPXxYkFVvPKNAgMPSthoVK9r+4
         SW33Dk9VSqbdY+Y/u0jCGZFN/PFL5BOJm+zJg2z1Q+INgaUdaXAkwG9tV7h4sHgztxBX
         LqKw==
X-Gm-Message-State: AOAM532BgwXO08tQGH9DG0dPTeVoasGqngZ+07hhgYbR0JU20dPdPTyO
        fMW3TiHdYIxaGK7Z0v/4jRKf7LpUJQsUm1dS1wXRVJo2U+TcUPWhOPC2rp9iahk2ODLoXdfGFIl
        8g3w+il+YfVtB
X-Received: by 2002:a05:6214:16d0:: with SMTP id d16mr2908320qvz.38.1604687058535;
        Fri, 06 Nov 2020 10:24:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjFRhUMcC6O0Xi4g7TUFBihyqqnSUi+JdTEDhbwl2AjXgP+c+ZnxTHtk1yMQni9Ih2fmcbHQ==
X-Received: by 2002:a05:6214:16d0:: with SMTP id d16mr2908305qvz.38.1604687058366;
        Fri, 06 Nov 2020 10:24:18 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id j7sm975327qtj.60.2020.11.06.10.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:24:17 -0800 (PST)
Date:   Fri, 6 Nov 2020 13:24:16 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: remove kvm_clear_guest_page
Message-ID: <20201106182416.GE138364@xz-x1>
References: <20201106102517.664773-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106102517.664773-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 05:25:17AM -0500, Paolo Bonzini wrote:
> kvm_clear_guest_page is not used anymore after "KVM: X86: Don't track dirty
> for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]", except from kvm_clear_guest.
> We can just inline it in its sole user.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

