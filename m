Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE7569F7A
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbfGOXVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 19:21:25 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46781 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731153AbfGOXVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 19:21:24 -0400
Received: by mail-wr1-f47.google.com with SMTP id z1so18799490wru.13
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 16:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xrzvaho3A7NJDnxvYTzF/283MeG9Dl/AO3DEbGN9Ayc=;
        b=eGLwWJlCz44ld2gJuZpgO326yoKTmeeO7/3MWXmOcAlq2pCCdl1WYdfrbfX01YtzNR
         v75liPpylmqKIjeAfjx2i+rHztDFIMTKnWTpHiif4XseTHWKsT7U+HdJnmaLCrEoZONC
         BCCWq7ks7wVqEMpsEggW87IJ5UUtlnVN5nraSRcVQckq0/x8oysB8ePphJFIn/ImXMw7
         JxeDqIp6MDOOuqNxdNbm0XLcgQjmRb2vzKoGvzgeEXpIv1vf0ITxM1mKI7WXWTL7xq4V
         ii2b4ajduyudvY9tdNIpzqxzRd/70lIQvS35kzXXoWeFBOfa7New69HR1gByQbh7GzfN
         RGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xrzvaho3A7NJDnxvYTzF/283MeG9Dl/AO3DEbGN9Ayc=;
        b=rLOMKd25r4NPu3f8fbXZgpvy1vtk+7eq/A76iJGyLlrBdrSxlLrBgmK60ldtvQHveu
         pCDRYlZ6uAZKiQPtJk42MBAi480IyoWBpNe1u4N06iQWDkiBwsLaYFUs5Ut4izS4N4Zc
         UrtMUZPy2fkFWFwX+c6XIwozAnwTy87XDYsbwB9xEmFgWsg4HNT2V61e+5+q1fGSiGav
         vNE95v31g2u+dyyLQmsuV9S6wnkZFStAxoxT4hBkAP05tNT4yBM67cY+Vkey7i5u3aaP
         K/anE7r7UbdMq/wr4G53r4EJooSj/ODtvE1YF3bnASCSAvCaRI45+WFzlIYw2/q47wFY
         ujTg==
X-Gm-Message-State: APjAAAW8s5dSGQyNfwjiKi/roYQ8u0F13KsHOtfAmGRvB1Aw1pzV9Tzt
        oV4OvpoEH+Ga+/xEe+SMs6AZPt+Qnkt9uDZ02FEFKhcU
X-Google-Smtp-Source: APXvYqxjPt9pMo4QAskIWlD4YfWcoj/oDuie3QBw7TUjW2WsVBlpyjlzxNPMg6CvrhTuxQ5LdzVBwE22WNSxzbogz+A=
X-Received: by 2002:adf:f450:: with SMTP id f16mr447458wrp.335.1563232882993;
 Mon, 15 Jul 2019 16:21:22 -0700 (PDT)
MIME-Version: 1.0
From:   Jidong Xiao <jidong.xiao@gmail.com>
Date:   Mon, 15 Jul 2019 17:21:12 -0600
Message-ID: <CAG4AFWb5M39RQS-x5Gz_xOMVHQ==u_HhZojunwdv2O+pvQG+Qw@mail.gmail.com>
Subject: Any function to access nested guest virtual address space?
To:     KVM <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, All,

I know this function cpu_memory_rw_debug() allows us to access a
virtual machine's virtual memory address. Is there any similar
function that allows us to access the virtual memory space of a nested
virtual machine? i.e., L2.

Thanks.

-Jidong
