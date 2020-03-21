Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0A18E4FF
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 23:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgCUWHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 18:07:52 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44881 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbgCUWHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 18:07:52 -0400
Received: by mail-ed1-f65.google.com with SMTP id z3so11742152edq.11
        for <kvm@vger.kernel.org>; Sat, 21 Mar 2020 15:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EXtE641hdKhdHDWsCnqJCMKB8YOjw5D/SFclwqkPa3E=;
        b=EHSbVeup2rq7iZraF62jO0Q5fFSAYF/P4n//GJrQInWeXuQzZ42WKTaWzZZz6ANMOj
         FFRmHSk9eQQF6Ndv2kH/BQkbVDz79HDvu+vDArMW+BtQ8IgjLEKDaJTFP//2Zl6Kt8MD
         5EVLVgno9/kiftpN1u9Uqwhljdj87STM/+YLrhPt6vgBbkNICoxPA7AKhwnpvKD/TZeb
         uPvomJIO0msQbv/MG8altVNSvO9D50KgwAiQ4Fhc8ixRkCy0fdh6BfB+br2tBNmF7ady
         ROIwMwUyxfRYgAofgpQGGoYVRyuZFu/7ZYyEaYIrLqWlzRTEZ2NaysnCKRxfJ1dzudUX
         cMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EXtE641hdKhdHDWsCnqJCMKB8YOjw5D/SFclwqkPa3E=;
        b=EYiHoWL6xNZ/1GoiRyts9kI6dNp7yMZR/PPLkdVYeIqlrfGVFIJqtT60+iGwVVdPBI
         bVPpQAkAlMr6jyb0+dul8gopZyZa8qQJsdJFCLiRoOeSdeCPH3OfCqI7CwHkRf3DRRhY
         LWGbNjTH6p8mmWhKOBKTB0mhHSkqrOoErCa6p7CKGlhfNwBiSXWo/uj7YcXOT3noUTMH
         BcWm6amMo7u81B5gF6EMn8F2Fl22r5WiCeRxRUvDjKJRTkohLUbRtzhUp9HpdYJ/q9DX
         huvkjJO59u0zd/GPHhnmiFWPIOC0cU7IwtBsZ4cmDCx6aEUni3dUOszZTug0CPexqPpc
         V3Hw==
X-Gm-Message-State: ANhLgQ0KHY884zM3hqlzDPEx4WSmfCsUn2szrZkk0LHjIXwzKwwvEZXa
        DN1vO80JwJKSww3k/DemJZRza5wH
X-Google-Smtp-Source: ADFU+vvAFOjpwnVFrwhIDDmqmcllHgnIIklFHo7GE9hIhd/q3eCoi623k1LQ4QFC70li99TuTG5qbg==
X-Received: by 2002:a17:906:6b10:: with SMTP id q16mr14250806ejr.170.1584828469802;
        Sat, 21 Mar 2020 15:07:49 -0700 (PDT)
Received: from [192.168.1.164] (i59F77C59.versanet.de. [89.247.124.89])
        by smtp.gmail.com with ESMTPSA id h2sm728789edt.44.2020.03.21.15.07.48
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Mar 2020 15:07:49 -0700 (PDT)
To:     kvm@vger.kernel.org
From:   Denis Obrezkov <denisobrezkov@gmail.com>
Subject: Is it possible to run KVM and guests on Beagleboard-x15
Message-ID: <2af8808d-1081-0a85-d353-38eee27860e2@gmail.com>
Date:   Sat, 21 Mar 2020 23:07:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am trying to run KVM guest on arm: Beagleboard-x15. It has
virtualization support. The only problem is that I can't receive any
output from VM:

debian@beaglebone:/boot$ lkvm run --name vm_guest -i initrd.img-5.4.20
--kernel vmlinuz-5.4.20 --console serial --debug  # lkvm run -k
vmlinuz-5.4.20 -m 320 -c 2 --name vm_guest
  Info: Loaded kernel to 0x80008000 (10277376 bytes)
  Info: Placing fdt at 0x8fe00000 - 0x8fffffff
  Info: Loaded initrd to 0x8f98ec48 (4658101 bytes)
  Info: virtio-mmio.devices=0x200@0x10000:36

---> no output anymore
---> here I stop VM from another console

  # KVM compatibility warning.
        virtio-net device was not detected.
        While you have requested a virtio-net device, the guest kernel
did not initialize it.
        Please make sure that the guest kernel was compiled with
CONFIG_VIRTIO_NET=y enabled in .config.

  # KVM session ended normally.
-- 
Regards, Denis Obrezkov
