Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BFA100C2C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 20:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKRTXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 14:23:42 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40476 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfKRTXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 14:23:41 -0500
Received: by mail-il1-f195.google.com with SMTP id d83so17066855ilk.7
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 11:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dT/xhzAc+qcTREFMJziHxhql11mxjnVJlIwa2Z0qOxM=;
        b=ogZ4ljgC5F8BBJpBToHoChJXsNVI449UVG/m+xW4d7H5RlfitDbLfCYGsCD3Su+l4D
         VL9e92laOxdgGn1wbaf6kOg8wrQ0ppEYavlkfb72f/a5/WNNetG1xnyfBng3zeyXN/uB
         fQG1Rc9c6+qKDow0phC5Z80TOuAlfI4+VUyxg4wWleicZdTkdKA7tyXkJu2Yqi0xM102
         rODnVAwaqnN9QGUxMo5YtjneYGumXatBgYZz1L1r00iJ2Njt4VuKZ4rCRCHRrJsbE2Yb
         p+jvWiv9LWu6NIdMxAYWEx3LPiNzzN3fG+nzkv/VnMM29DAodEi1slGukKh1De9fo5tk
         S48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dT/xhzAc+qcTREFMJziHxhql11mxjnVJlIwa2Z0qOxM=;
        b=HbFEwrZlpH97GutlDrZ8giYNO8/eIZoIlgcBOCuVBJT1LsMSBlGZ7IMqUbXDicyVxR
         7lw3lFQMIGnaAcB8fnVn2Igu7ELNy7ov16mcJ4wD0flMHR327+S9yg87fWfiwLbz0dtG
         5ThdMmqDzCY6R0Prh6/c+2MkN4Lw3rdlx9lq2qpZfL1XkNHf5EStuPvZLKv5KSVwKn63
         0ARdBeirgNz0USLZSkjcS/CXUXqgwdlgBlQL002gXipbnZjYpCpDhbCVrGdy2xl+cLs9
         aX0/xe7x9Ghr2YU1T5A8rDtO9+tNVgi8iRIjmHAuqLcbcwJJfe2ATnpP1ph9l4p15RHE
         hb2w==
X-Gm-Message-State: APjAAAXpWvjimfUhNy6+ySIcGiZkj7zTd4Yc+c05Hnrjf6Fh4pEBFyVS
        fuTpM/vQra6CtAVFK3qhU1llc7H47RSRd55/Of3Kyw==
X-Google-Smtp-Source: APXvYqyTLTOzWL8xtA5ioL5fETU5hBSfnqr9qyzpOJx7wDcfjl65qgfdzf44sTUY6wUJHGN1BIV/HY6P/mBwKt1+rKQ=
X-Received: by 2002:a92:ce0d:: with SMTP id b13mr17843073ilo.26.1574105020622;
 Mon, 18 Nov 2019 11:23:40 -0800 (PST)
MIME-Version: 1.0
References: <20191118191121.43440-1-liran.alon@oracle.com>
In-Reply-To: <20191118191121.43440-1-liran.alon@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 18 Nov 2019 11:23:29 -0800
Message-ID: <CALMp9eQMfMfhdteg4N6u5dM3DRw9E7WXON77jnjkxN1QgQXHZQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Use semi-colon instead of comma for
 exit-handlers initialization
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mark Kanda <mark.kanda@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 11:11 AM Liran Alon <liran.alon@oracle.com> wrote:
>
> Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
