Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5480946C851
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 00:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhLGXmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 18:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhLGXml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 18:42:41 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB429C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 15:39:10 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id bf8so1539244oib.6
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 15:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y0HrPBwcAFwIEMtY9UPWt+7UTVE+tRhBMJIFTdr4Pzk=;
        b=gaFYFNpl3Ef92OOwbILyY09G/ZTT+XwJ19tje7c2Smaq9lcMIA3VkQOimnYIjSnj6W
         2CY8HJ1IP6hgokGHUwxbhUWqeGLhWhZUG4DRHMhPh2cA2eDPx4rgCbgnMBn85GKgSY52
         GMMf+zSxxfoQ2AzygMUVE3JejOCGP2t9kpLesNPqGUxBg5SSGcL1uecQkZITKGe/UqNl
         DHAX13xUOPe813+gKwBBkvTg4IikSnL1kyuL0GMRgTTL6+EmGOdVthkjKtgt+vAdIBIl
         sxptjcrOD7HBLBvpsTOM93TnEukYSPADaWa0h7NJF09//2UrbrzscbdsSNlEyrxalk87
         e3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y0HrPBwcAFwIEMtY9UPWt+7UTVE+tRhBMJIFTdr4Pzk=;
        b=F49yPpxLov8KJnSepW0IBSUDaa8tGoytNQUqNTAuPpqai0zxR1za3mmT37jKsjuRAG
         PUJmLReVx40L+8kmzMtk+iCu584A9yiJk4iMZ4XYynLGyUk8B4TKF0pVRxg87n77elm+
         813Kodj/Pf5BLRt25kWSpW0/ENhqHqfLkxTzH68z/CAjGBRnsFb1KLeF+UchwGOQTLHl
         +bkRrFsFUUeMGW7LcGxVKlmJOv6fWzEOJmT8rQZjL153Tc5yDz7Qia+snrTb5EnEy+Py
         UbVQhYUtXEj5FZkimlboD67WAn+vXy3C6v11CvBe0Ab2ajyjeoAlkhrGSlC75M2AgxAV
         FrXg==
X-Gm-Message-State: AOAM531wGm2j6gV+CEnjt0cs7pDrOJqd9aixMk9jCuV65LvX0Yj2PfIC
        +75vSFqXIiUXhGY9SznDLI2DBLhPST14dCzFwX8pWKU5syCEMQ==
X-Google-Smtp-Source: ABdhPJwejACRf6xB8ynudVufmH+WSphOngyOq1Ihn/aC5wUuC3I83I0oCLd5Bf8G83uwsVYq9te1MY75XG6fnPp8ODo=
X-Received: by 2002:aca:674a:: with SMTP id b10mr8484801oiy.66.1638920349725;
 Tue, 07 Dec 2021 15:39:09 -0800 (PST)
MIME-Version: 1.0
References: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
 <20211207010801.79955-2-krish.sadhukhan@oracle.com> <CALMp9eS9_z6_47nRTaj4+dygzwA0-DsUT2UGMqjb-GnqEWHEuQ@mail.gmail.com>
 <594c0c00-f0ce-9d17-157e-242ad91f69fe@oracle.com>
In-Reply-To: <594c0c00-f0ce-9d17-157e-242ad91f69fe@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 7 Dec 2021 15:38:58 -0800
Message-ID: <CALMp9eQy=PdUomH4Pa66CjUd=qZMR8LxeQDpM7h6Vk1znSxTwg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 7, 2021 at 12:09 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:

> OK. If the processor's physical address width determines the MBZ mask,
> should we also fix the existing test_cr3() in kvm-unit-tests ? That one
> also uses the same fixed mask.

Yep.
