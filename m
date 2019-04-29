Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937F9E1AC
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 13:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfD2L4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 07:56:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43602 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfD2L4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 07:56:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id a12so15583226wrq.10
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 04:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fIbZ9okd6K5G9HhJLJahhFQ8tK+F0yIfEuDsjnNydBw=;
        b=YHau91Wy/ssGb9QvZsO2YZLzqJ2+MPxpMcO0s6vHHsLF5Bxys2o3xTbraELWePZvtC
         NnllRvvYeCYMDzhjsSOiM5vVL2FaeuEQRBO01m9WzbexB9mvKV+rKXk6Wkq8JEbljoHC
         B781YxKUl43Xo99UzxZpc6l3Mz5Y5A+xjhlCFOcPx8JBnh2g51L7NbtJWldmGZpgtzJv
         g/gVnYaQyfvariO6L7AeLJVQ/+wtLhY8iLZIbL0ytJdQsfvQWpFa/M9/D0MR2E/s1d6i
         zcZIiKeimGviG1TUQrmK6BGEVFk3qohjrLebSdyUbMpi4Ymo5712Kixy8nUUK8r9R38u
         EeBg==
X-Gm-Message-State: APjAAAXpZ57Ne4nsZ7AHtLJ5hUUtnv1YX+RExYfD7YuvnpS2EEBVfWq2
        oKOwmZ5zkwSvcKlNfutYPN6wgOTQbn8=
X-Google-Smtp-Source: APXvYqz4p53tPATUu8/nges94oWB2B+nPC0gx0UocblAcz5pmHBkaIhxYL32u9bLhnDYN4PgkFpkNg==
X-Received: by 2002:adf:f309:: with SMTP id i9mr39385979wro.258.1556539005529;
        Mon, 29 Apr 2019 04:56:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w10sm26599917wrv.8.2019.04.29.04.56.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 04:56:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Christopher Pereira <kripper@imatronix.cl>
Cc:     kvm@vger.kernel.org
Subject: Re: "BUG: soft lockup" and frozen guest
In-Reply-To: <1798334f-3083-bb4d-410c-849dc306e6b2@imatronix.cl>
References: <1798334f-3083-bb4d-410c-849dc306e6b2@imatronix.cl>
Date:   Mon, 29 Apr 2019 13:56:44 +0200
Message-ID: <87muk958jn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christopher Pereira <kripper@imatronix.cl> writes:

> Hi,
>
> I have been experiencing some random guest crashes in the last years and 
> would like to invest some time in trying to debug them with your help.
>
> Symptom is:
>
> 1) "BUG: soft lockup" & "CPU#* stuck for *s!" messages during high load 
> on the guest
> 2) At some point later (eg. 12 hours later), the guest just hangs 
> without any message and must be destroyed / rebooted.
>
> I attached the relevant kernel messages.
>
> Host (spec: Intel(R) Xeon(R) CPU E5645) is running:
>
>     kernel-3.10.0-327.el7.x86_64
>     libvirt-daemon-kvm-1.2.17-13.el7_2.5.x86_64
>     qemu-kvm-ev-2.3.0-31.el7_2.10.1.x86_64
>     qemu-kvm-common-ev-2.3.0-31.el7_2.10.1.x86_64

This is pretty old stuff, e.g. kernel-3.10.0-327.el7 was release with
RHEL-7.2 (Nov 2015). As this is upstream mailing list, it would be great
if you could build an upstream kernel (should work with EL7 userspace)
and try to reproduce.

-- 
Vitaly
