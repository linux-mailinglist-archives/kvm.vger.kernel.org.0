Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4D340B5F2
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 19:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhINReQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhINReH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 13:34:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698BC061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 10:32:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n4so8705011plh.9
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 10:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uuB6WFLIwWapJPUQWcB2Kv5KA49vQ2VGYpyDhpmsn5s=;
        b=FbhetDrEjnwyCwxxkyOS62IWKG83CV+Pyc6FmO8RiYnUWRm0dtGq+M20733MOX0nty
         9mQ8LWhIjb5ymv1z1AerabI3Fw6A++M1KrW0+/nQlRTN//phjBhsC0CnYokjPun+6R9R
         EqcBM5D3im4CYFRqjN6L1J18ReNKMx3Osys+vg8g5JneWFAGpB1GuBTuov8t+6oqhDfs
         dEu3LXKZef++ifkNdfGZbonc4WlPtdfNJGPBbCzRriR0ci2n7UbS3BdDrO0HoW2OkzcY
         7i7Aw3Ph2roKzJS7Vw+9abmJlfxdEwAqqdgNp0lA4lOuPhX9gMcXdgGxA0noFBDQANL3
         Qq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uuB6WFLIwWapJPUQWcB2Kv5KA49vQ2VGYpyDhpmsn5s=;
        b=K4Jc2f0rnZHSwCD5uH50Z1xYSmWrmUO/RWKfhRvdLZXHn0/DC3htr/zf5SrYwgpV/J
         U6R49XShk/pFh1FxMx3HfbILiwuFtKFvqiilTg7NG9jmOgQMHsB+QoUxmfH+zSOkqsNq
         qklWGeoIEIC9DU1Wh5pn0qPS7fPw1KL9Ts9pT4I3H+YDy8duYIBYgMI4J7CL9ZV9tUEM
         3hA30CZIysW5PhtI/LSyYtNkud5RZi4KNaBzn4C+dQuUp+K/wNhvtiC4JAX/tI49fOi0
         T3ITA+Rq5jtD24diPcyQ1NkFWBn77XLm39pFRaougupWQ25Lnm/t9aXyNRHrxUrO5ruD
         jiNA==
X-Gm-Message-State: AOAM531N9HFvTJl7ebUIU+dYEY6J9J5GSJ/ej+wfcnF9ZQN/mYcbNK1G
        VLTMjau0yHJE9NeVf2tL+sRBAA==
X-Google-Smtp-Source: ABdhPJwxQ3GBt33aFswDWpHqFURv5eOW64rFsjKvyrEXPnm6hekDo0Fq8+7h7eHpKO/GRZgYwQ+EhA==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr3315056pjq.64.1631640769453;
        Tue, 14 Sep 2021 10:32:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u12sm11981643pgi.21.2021.09.14.10.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 10:32:48 -0700 (PDT)
Date:   Tue, 14 Sep 2021 17:32:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for
 SEV-ES
Message-ID: <YUDcvRB3/QOXSi8H@google.com>
References: <20210914171551.3223715-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914171551.3223715-1-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021, Peter Gonda wrote:
> Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> SEV-ES guest.

What happens if userspace does KVM_CAP_VM_COPY_ENC_CONTEXT_FROM before the source
has created vCPUs, i.e. before it has done SEV_LAUNCH_FINISH?

Might be worth noting that the destination cannot be an SEV guest, and therefore
can't be an SEV-ES guest either.

> Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")

Cc: stable@vger.kernel.org
