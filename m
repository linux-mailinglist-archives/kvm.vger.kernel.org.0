Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4598C294126
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 19:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395153AbgJTRMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 13:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390192AbgJTRMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 13:12:22 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C676C0613CE
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:12:22 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id q136so2896110oic.8
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=TnQWFq6PlsNzb2Pdo04Z3ZD92uvkhYe9cU0O+K4el9w=;
        b=g5xMeMVi6AwqQaMxooxRde02kKLx44lmSnI6n5JbMWK9QlRWVYD0hd6hr6/lqctj9b
         NLajLBAGjOp9nNz/7KnayOnbprUkQZAywy7Gei411trQMLDF6UR3eiMvo3K6WWERsOmo
         s9N/pH0nLFR1Z85uRMQ4mvmi8l07gUwryQNcyNf0U4fo4RBjPl3g0LM8fkvs6jsQINj1
         JTbtV5Mfe5VH8HfIiRzbIFhjM+oeUOyfcGWQ+Zz/opLF3KA3LEpFFB1ThWFvrD496Uve
         SYOxKz1lrDRpYor5xbqI38r9HWKKK5sAYNYpaO6ovPuJd9quZB3Vwv9N2TwshVr0KDIK
         LiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TnQWFq6PlsNzb2Pdo04Z3ZD92uvkhYe9cU0O+K4el9w=;
        b=HWr4A+4c/7HCr4erPVxnZt5DYZj77ZMZC5V3STNFWTShZDc+w0iWYGRg/qTrkjYfTN
         Z3kW1mP3XkOosFCe6vGP+GCSRIswwz249X4vL3WnHtdaaekPGBjf56Hd6m/PpZOI+7jC
         TOaxY3zCJkfiYBpbdqQKfjPChfST6GT7twVhbHugU0YIN0JdE/O3LX0sAzjRaZnRU8ED
         Z66Nk8cOgCjGpmj2aeiPklf9/yDEveDd4l3FPnmhTuGZ/f+GQdciJ+9VOZDIhlr3UR0k
         7XmSXNTs/Ti0DEwNWG0QcEPMYRr1L4lqgTpFO7jI516lmmYPeyMoN1ASN/D65UeIT2nC
         v/Og==
X-Gm-Message-State: AOAM533bAGKyQld3zm81U2YaWAmtP0X2rsvZflIEG40sjw9fQOHV0MnQ
        wj+Rdy4i94L744ufCOE9qrbTLOERL49TpGXRf3iLPneQrAI=
X-Google-Smtp-Source: ABdhPJzDuXKxslqzKafb4zNgPruT78455kNtMq0Zn7hZ+Yj7BZ4DwozTplReslg1yAZpoyjCSCIgnwYkr2FMy4LoYWM=
X-Received: by 2002:aca:f202:: with SMTP id q2mr2400033oih.6.1603213941232;
 Tue, 20 Oct 2020 10:12:21 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 20 Oct 2020 10:12:09 -0700
Message-ID: <CALMp9eRYN7acRAOhoVWjz+WuYpB6g40NYNo9zXYe4yXVqTFQzQ@mail.gmail.com>
Subject: CPUID.40000001H:EDX.KVM_HINTS_REALTIME[bit 0]
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per the KVM_GET_SUPPORTED_CPUID ioctl, the KVM_HINTS_REALTIME CPUID
bit is never supported.

Is this just an oversight?
