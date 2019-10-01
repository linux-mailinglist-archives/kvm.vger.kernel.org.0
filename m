Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6331C414D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 21:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfJATsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 15:48:21 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:35025 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJATsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 15:48:21 -0400
Received: by mail-io1-f48.google.com with SMTP id q10so51281626iop.2
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 12:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SPNzekFnF2JnHfMAXwLn6fIJa3o3huxweFULHgUFhk4=;
        b=sOj8TPiNYKNWZNLgqDMTa+2yb67iFsiavaMRG582ml87GqB3dw/YSh2pc5g9VUEIFo
         DAFY7PttMSG951NQYMO+55zJlXD3mi79rsvNzu4N1flLkqSQ3tiOXEQBDJZ1WQmyCK+d
         6QsTs3Hi4c1e9TLqOqgZF4oo3MRxfATWlaxYD+YkCDY/ioNYC+HnVhGncAfxrYJbRUuy
         Zku4SKbgsheqDJendMAjBbg5Juumaehz8rHcfTRTL3aoNg5MXtDHx94FEVNiHBvHInIX
         QCnGppKOz0urT52H3/gGo+kljzIuEj/2bS6G/+xpUZu4uxurCBV5MZL1YuxSEoWEolnI
         ZPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SPNzekFnF2JnHfMAXwLn6fIJa3o3huxweFULHgUFhk4=;
        b=p5nrsH+qos28+YO/neLg1kUk71SspCwVVrNpWZaTryknKsGI2qIQbi2aD1rUoQd6NQ
         u05g+PCBfdpKcInsro2HEp+hzn4TKTBm26N9LyFGStZVNm3KSJMyxNKdZIsV/QaRw4Ss
         pSHpR0jYOJOP2j3s7DP/hu4EZJ4oaUZwQEN9tQmHJZbaWZOORuW9lnhF9h8kfJBL/get
         yaLxK5Sn3F5P540yu2AimBX/rKwuaXtoJCzYvkv7sPrNNSsl26nTMiqCjrrMuCzp7pT6
         TV6NEUqlxzKO7dWGXuIANDUQMt+zEOu9Iwbfe+kOXNhCb05Zp7nuvWC3p4LDSyzSMa83
         Bdig==
X-Gm-Message-State: APjAAAUAQIApUO4tXtGXAwDz9AM9YsBDqJjcNkxfv9SL88Mrpypg7Umg
        xudTZPxFXVgIz+FmJVbpp5Phl/G/l6MSBtTHHunxvRuPjp4=
X-Google-Smtp-Source: APXvYqweqo0pUEdvI4+kZYGqG8V57Do0jFiU9qBZCWto6nR+MvVUPGAOHH4oLVwyhFwQOr8sMFG4mO6I3mYMYhhSfRo=
X-Received: by 2002:a92:4a0d:: with SMTP id m13mr26870967ilf.119.1569959300095;
 Tue, 01 Oct 2019 12:48:20 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 12:48:09 -0700
Message-ID: <CALMp9eRPgZygwsG+abEx96+dt6rKyAMQJQx0qoHVbaTKFh0CqA@mail.gmail.com>
Subject: A question about INVPCID without PCID
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Does anyone know why kvm disallows enumerating INVPCID in the guest
CPUID when PCID is not enumerated? There are many far more nonsensical
CPUID combinations that kvm does allow, such as AVX512F without XSAVE,
or even PCID without LM. Why is INVPCID without PCID of paramount
concern?
