Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85666136E
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 03:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfGGBTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 21:19:31 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:33601 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfGGBTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 21:19:31 -0400
Received: by mail-wr1-f50.google.com with SMTP id n9so13435857wru.0
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2019 18:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=mHGaMIkIHgR5W5GBE4MbBOlXpjzscLPMPDa9lxC5WZ0=;
        b=X7ShMRw9E11Qqa0KY7/Efwg1OYn5A5SFM9xhQ4zfzva+zdqj49Ma7wcqV7mIhLmZ9R
         suQMn3NgaY8SVs2PR/uhI+/lfhYFnUQM+1EFf2aPw8BrRfI0NS5uzNo7CRtI2arkC/R3
         f8PJwPdZbKMcEVFVbOfhZWy9iDkj5LI+7Ol/0bi+yER+3NZUTjOYezEqACSxZ5JPCWRE
         GtXQBN3LOs22oPQDDnhs78jkc8TbWehbrIkfl1eCB9gRBoqN2Yrep4Lyha4ctZ16xR17
         cYf5PP/WaTSVPoI1uFdcEK0XodseFdK4NcarXxLqrdEWTICduEwGTR+kR71GVSe8HJVB
         qwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mHGaMIkIHgR5W5GBE4MbBOlXpjzscLPMPDa9lxC5WZ0=;
        b=HANwfKWIqSySa4VIpSMt0cUIsmR2semoRsMYnFhpLT0KWqpeZTBe4/UWdW6498k8Ff
         7pYukQmgM6jxrAdvOTJSTtXdED4waLFuH75qMcDhbYyl/1KQUhb/j0Yz6dqzgLGeo4FC
         7dJtTeLixibEEZ5Y5tLUIU+bzygUUhAb4JRuWFJgwqLkQAjahjQtX4wp/ultcCFiV7Wj
         gC7L73qGtc1nlPysx17d3YWypC3GGd93yHr9H+/nKMKYKpAR+1DQMDVNYQ0OQ25aXLbO
         Ek18i7/P+phWq3Kc83220vag+eaX9aTSyLiJ/vb+evnY9QiOiCRYLePweGL1gIyHG0aP
         dnig==
X-Gm-Message-State: APjAAAXcvCSmf1/VE6h2eFjiyNeFydIweXGoGVfOAgWHKYrvEsjgh9d3
        okgPGZyawLTOh5fXlg67yVacH6WX4wwLUobPszgVFMD2
X-Google-Smtp-Source: APXvYqy5h3w+hBaWCn9KCSqxcfKxtt4AW/rylPotZEwuHbVmm89HPZpyuhfCP22l2POX7oWEIiylFzQWffqdgtcE5j8=
X-Received: by 2002:adf:db12:: with SMTP id s18mr10235515wri.335.1562462368644;
 Sat, 06 Jul 2019 18:19:28 -0700 (PDT)
MIME-Version: 1.0
From:   Jidong Xiao <jidong.xiao@gmail.com>
Date:   Sat, 6 Jul 2019 19:20:31 -0600
Message-ID: <CAG4AFWag_Q44SetzaZBpD8963NG-H9ajc8GHq07zVv_xaE9WKA@mail.gmail.com>
Subject: Nested virtual machine introspection
To:     KVM <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We are working on a project where we need to explore the virtual
machine introspection technique in a nested environment. More
specifically, we want to know if from L0, we can reconstruct the
process list of L2. And to begin with, we just want to explore a
relatively simple case, i.e., only one virtual machine at L1, and only
one virtual machine at L2.

Several studies have shown that from L0, people can reconstruct the
process list of L1. For example, in the context of Qemu/KVM, the
process linked list of L1 basically is existing in the L1's kernel
space. And in Qemu, the function cpu_memory_rw_debug() allows us to
access the virtual memory of L1. With the help of this function, we
will be able to scan L1's kernel space thus reconstruct the process
linked list.

Now considering there is L2, can we still use cpu_memory_rw_debug() to
scan somewhere and find out L2's process linked list? We have tried,
but it doesn't work. Any hints on this? Like where exactly shall we
search?

We have been stuck in here for quite a while, any suggestions would be
truly appreciated.

Thanks!

-Jidong
