Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA89D52A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 19:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbfHZRp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 13:45:56 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:36578 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387458AbfHZRpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 13:45:55 -0400
Received: by mail-ed1-f47.google.com with SMTP id g24so297134edu.3
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 10:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Q62liTT+hhM+0qwmLKgO92440LjoZ1xAo8wZ/dbysRg=;
        b=nsQtQw03QJ4n8duk+xxlZvoHcw5S3cIFCij9bwmMjZfINA8G6ZjaJ5hdXZH2/SBitj
         dBoSdmoj+zZvGkGU+XurvUc0eX0GayPiLtmI6Nec7vozESS1qSk7FKCJhUo+XjkFZRcU
         XT2AiCkO+IXMeF29XVTuOrnJHBcIOK4xS+FNJlXKMlDAu4AJU9RP/oy35uT7WQGin+fB
         uNvKyzNxcb/PM1kbfkelLu0c5PNwn0Je+X1sJuZfGfoRGSN1n98lvOsqEDX5y93sKfOn
         bqm9GpIXhPzR+styplECBC56L1awc9NxbPnN0mqEQgh/7T0LF7cRTkcXcK8pnRtVlJSC
         GqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Q62liTT+hhM+0qwmLKgO92440LjoZ1xAo8wZ/dbysRg=;
        b=GzA1mHaBUI6jlxWRWA5TTaJFMdbv+WdFU85EGJumcb9Ls1T5KUlhXkyFMzkdJMz10J
         mJ3iK+qfbJiJ67epl00liaXKqnkTUOAUMqlI+6sCFQYRGWfhJETRSgTqELxg/rfIgcRK
         7qgHE6W8NjOLuoCPcKwqGEsiLxhsizNNASpkZxykxKc/1bgcY+mw1Ixk8sfFSKOfL0G9
         nHsv6r+khh4xaO79KKAClD63PpsN45sN1uQA9tjNEokno3kquE9pTq6EHRzoWwq7l2nY
         QBmOLrTX6squAQ6mnKxXqzWh8dHCWtKMS4Dz4XInVNs2oh9e7LAUb9Ah1IfVf5ElrUSu
         tTsg==
X-Gm-Message-State: APjAAAXiTMv4FjOlK2iWM6XESU3//VPoB2H2XGybW/ESFB1peyYTm1MR
        EfpIue06i3c1EKJKLdH4nkRz3DqeJXaduKztTF63L0YwfTY=
X-Google-Smtp-Source: APXvYqzMTY9j02EDfdNdmNQopurwKxIeeIWs+08VX4IXLeylhZOvMyuJYXVYUhPMRw5yY2Hvq9hsoPS8GPfUm87icSk=
X-Received: by 2002:a05:6402:170f:: with SMTP id y15mr20586898edu.55.1566841553033;
 Mon, 26 Aug 2019 10:45:53 -0700 (PDT)
MIME-Version: 1.0
From:   Kaushal Shriyan <kaushalshriyan@gmail.com>
Date:   Mon, 26 Aug 2019 23:16:13 +0530
Message-ID: <CAD7Ssm-fMeQ=P+sOaLwbMtHkpHzBbn9yFda-T6MC809ESL5txA@mail.gmail.com>
Subject: CPU and Memory requirements for host OS ( CentOS 7.6) on Dell
 Poweredge R630 serve
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am running Dell R630 Poweredge 1U with 32 cores vCPU's and 96 GB
RAM. What should be the minimum numbers of CPU cores and memory that
should be reserved for host OS (CentOS 7.6) and the remaining CPU
cores and memory resources to be allocated for Guest OS?

I look forward to hearing from you and thanks in advance.

Best Regards,

Kaushal
