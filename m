Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C1BB7A6A
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389595AbfISN0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 09:26:02 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41699 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388408AbfISN0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 09:26:01 -0400
Received: by mail-oi1-f195.google.com with SMTP id w17so2658896oiw.8
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 06:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hmtA+x4AdVtvOO2BSWhLjM0XYkfRJORb4qO8gBWVHtY=;
        b=yCcvo0DJzBAoVAhGUhOJUtiN9+Z259EVxR0whCETfBFEEmi9RDdB4VopwOVrNm0s3z
         s9DtdfuS2458Dr60kBBOYtMtvOyk+j/V3NOD3JLCkDfd5xf++qRIUnWaCFidV6afCTP5
         7jRGptjHnzZYtY+e/r5qVOm5E/b8Jej1YWo9AKi5qxT4i6C7mkC0U24iLE04N2KOrEkP
         XOg5AWRnw8yLYyuX5MhepxSWvJ9VT4ROeZozks0UN51rFzGfvonRpi46KQa3EgRX4wjC
         Xj/lnRQuQbA/GPh0EgrJKpjF6AnnUhFf0XqaBuAxLkQdMm0GV8fw/ZXqN6EMPhyE4y0O
         tr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hmtA+x4AdVtvOO2BSWhLjM0XYkfRJORb4qO8gBWVHtY=;
        b=r01BNEqEDo3Dg1yxgX6DltDn6IJQzu8chZbeRBTin/f3QSuwh9sAORBNbeYAiQIUyZ
         NpZ2ltT7E7YX53qRdDsxc/LQCzAmE7hZUwjXhwRKDYv3/jrxvy32sdIxu4I4gKzN4t6y
         xDruA4qlQmDDqjiwTT8A3iHPYpzMjXk+t17/Z3E3VE/ae7R7VkW0SqvgSpIBLmFm5gls
         L8ciWtyXp7N12zWLBFBhZpWYbE12Tw/0owFyheCw0qcEVyQi7ESunDLh7zFKZ4fiGz00
         Mxy2QkmdLnGMYvY1YtBI61pqXv6cFGgHJGMbfT3tQco0SerwTN+h6QQ+fTJK8imynmsN
         PCzg==
X-Gm-Message-State: APjAAAW+h36UyznyX3ep6Fib1wYUZaDQwlfSW61hHOp4NGe4isnDP20W
        4UvxuLbjSi+GUi56IP80UbdvOgl7Y8eu9HlTlJcCgA==
X-Google-Smtp-Source: APXvYqx6ds8Gqm4QHdytrchiFfVqhwMnVbIIhqfYJVJmtolzn2WvhWgL9hnLN7pIVtUz4m66OjKl9p4RQRosq6MV0vQ=
X-Received: by 2002:aca:53d4:: with SMTP id h203mr1990335oib.146.1568899560540;
 Thu, 19 Sep 2019 06:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190906083152.25716-1-zhengxiang9@huawei.com> <20190906083152.25716-3-zhengxiang9@huawei.com>
In-Reply-To: <20190906083152.25716-3-zhengxiang9@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 19 Sep 2019 14:25:49 +0100
Message-ID: <CAFEAcA_MGiatTVCEbnoy5D7S_j9H1DyPkqWMb8uBKL_oycyVDg@mail.gmail.com>
Subject: Re: [PATCH v18 2/6] docs: APEI GHES generation and CPER record description
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Sep 2019 at 09:33, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>
> From: Dongjiu Geng <gengdongjiu@huawei.com>
>
> Add APEI/GHES detailed design document
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  docs/specs/acpi_hest_ghes.txt | 88 +++++++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
>  create mode 100644 docs/specs/acpi_hest_ghes.txt

Hi; new documentation in docs/specs should be in rst format and
listed in the contents page for the manual at docs/specs/index.rst,
please. Conversion from plain text should hopefully be fairly
straightforward.


I've also provided some minor typo/grammar fixes below.


> diff --git a/docs/specs/acpi_hest_ghes.txt b/docs/specs/acpi_hest_ghes.txt
> new file mode 100644
> index 0000000000..690d4b2bd0
> --- /dev/null
> +++ b/docs/specs/acpi_hest_ghes.txt
> @@ -0,0 +1,88 @@
> +APEI tables generating and CPER record
> +=============================
> +
> +Copyright (C) 2019 Huawei Corporation.
> +
> +Design Details:
> +-------------------
> +
> +       etc/acpi/tables                                 etc/hardware_errors
> +    ====================                      ==========================================
> ++ +--------------------------+            +-----------------------+
> +| | HEST                     |            |    address            |            +--------------+
> +| +--------------------------+            |    registers          |            | Error Status |
> +| | GHES1                    |            | +---------------------+            | Data Block 1 |
> +| +--------------------------+ +--------->| |error_block_address1 |----------->| +------------+
> +| | .................        | |          | +---------------------+            | |  CPER      |
> +| | error_status_address-----+-+ +------->| |error_block_address2 |--------+   | |  CPER      |
> +| | .................        |   |        | +---------------------+        |   | |  ....      |
> +| | read_ack_register--------+-+ |        | |    ..............   |        |   | |  CPER      |
> +| | read_ack_preserve        | | |        +-----------------------+        |   | +------------+
> +| | read_ack_write           | | | +----->| |error_block_addressN |------+ |   | Error Status |
> ++ +--------------------------+ | | |      | +---------------------+      | |   | Data Block 2 |
> +| | GHES2                    | +-+-+----->| |read_ack_register1   |      | +-->| +------------+
> ++ +--------------------------+   | |      | +---------------------+      |     | |  CPER      |
> +| | .................        |   | | +--->| |read_ack_register2   |      |     | |  CPER      |
> +| | error_status_address-----+---+ | |    | +---------------------+      |     | |  ....      |
> +| | .................        |     | |    | |  .............      |      |     | |  CPER      |
> +| | read_ack_register--------+-----+-+    | +---------------------+      |     +-+------------+
> +| | read_ack_preserve        |     |   +->| |read_ack_registerN   |      |     | |..........  |
> +| | read_ack_write           |     |   |  | +---------------------+      |     | +------------+
> ++ +--------------------------|     |   |                                 |     | Error Status |
> +| | ...............          |     |   |                                 |     | Data Block N |
> ++ +--------------------------+     |   |                                 +---->| +------------+
> +| | GHESN                    |     |   |                                       | |  CPER      |
> ++ +--------------------------+     |   |                                       | |  CPER      |
> +| | .................        |     |   |                                       | |  ....      |
> +| | error_status_address-----+-----+   |                                       | |  CPER      |
> +| | .................        |         |                                       +-+------------+
> +| | read_ack_register--------+---------+
> +| | read_ack_preserve        |
> +| | read_ack_write           |
> ++ +--------------------------+
> +
> +(1) QEMU generates the ACPI HEST table. This table goes in the current
> +    "etc/acpi/tables" fw_cfg blob. Each error source has different
> +    notification types.
> +
> +(2) A new fw_cfg blob called "etc/hardware_errors" is introduced. QEMU
> +    also need to populate this blob. The "etc/hardwre_errors" fw_cfg blob

"needs". "hardware_errors".

> +    contains an address registers table and an Error Status Data Block table.
> +
> +(3) The address registers table contains N Error Block Address entries
> +    and N Read Ack Register entries, the size for each entry is 8-byte.

". The size".

> +    The Error Status Data Block table contains N Error Status Data Block
> +    entries, the size for each entry is 4096(0x1000) bytes. The total size


". The size"

> +    for "etc/hardware_errors" fw_cfg blob is (N * 8 * 2 + N * 4096) bytes.

"for the"

> +    N is the kinds of hardware error sources.

Not sure what you had in mind here. Possibly either "N is the number of kinds of
hardware error sources" or "N is the number of hardware error sources" ?

> +
> +(4) QEMU generates the ACPI linker/loader script for the firmware, the

". The"

> +    firmware pre-allocates memory for "etc/acpi/tables", "etc/hardware_errors"
> +    and copies blobs content there.

"blob contents"

> +
> +(5) QEMU generates N ADD_POINTER commands, which patch address in the

"addresses"

> +    "error_status_address" fields of the HEST table with a pointer to the
> +    corresponding "address registers" in "etc/hardware_errors" blob.

"in the"

> +
> +(6) QEMU generates N ADD_POINTER commands, which patch address in the

"addresses"

> +    "read_ack_register" fields of the HEST table with a pointer to the
> +    corresponding "address registers" in "etc/hardware_errors" blob.

"in the"

> +
> +(7) QEMU generates N ADD_POINTER commands for the firmware, which patch
> +    address in the " error_block_address" fields with a pointer to the

"addresses". Stray extra space after open-quote.

> +    respective "Error Status Data Block" in "etc/hardware_errors" blob.

"in the"

> +
> +(8) QEMU defines a third and write-only fw_cfg blob which is called
> +    "etc/hardware_errors_addr". Through that blob, the firmware can send back
> +    the guest-side allocation addresses to QEMU. The "etc/hardware_errors_addr"
> +    blob contains a 8-byte entry. QEMU generates a single WRITE_POINTER commands

"command"

> +    for the firmware, the firmware will write back the start address of

". The"

> +    "etc/hardware_errors" blob to fw_cfg file "etc/hardware_errors_addr".

"to the fw_cfg file"

> +
> +(9) When QEMU gets SIGBUS from the kernel, QEMU formats the CPER right into

"a SIGBUS"

> +    guest memory, and then injects whatever interrupt (or assert whatever GPIO

"or asserts"

> +    line) as a notification which is necessary for notifying the guest.
> +
> +(10) This notification (in virtual hardware) will be handled by guest kernel,

"the guest kernel"

> +    guest APEI driver will read the CPER which is recorded by QEMU and do the

"and the guest APEI driver"

> +    recovery.

thanks
-- PMM
