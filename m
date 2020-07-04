Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5362146C5
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgGDPGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 11:06:19 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42854 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGDPGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 11:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593875177; x=1625411177;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=R7ccU/N1wUG2cYHnGhImJaNpAoGB23p3cOO7bV/+heQ=;
  b=vBym4Rs38WlStpXNpQuAlX8RyR6o3jTTrHXrY+7c5A61VQoqez9VPVao
   icuD9bd3dqT7+4rOqWp/zUAZnNlDw7J/MDVsG2hXtiwQhXI+qukgEhmQf
   +8XM9qriACqzHV8volGisd5HoCnzmYKvUPT10ETVo+DSdNyqUESa2rPm+
   k=;
IronPort-SDR: Q15QUAqYuHangPG8Z8KH/xEzfFuJD3cA/xaMxSWf4rsUVnfK/tVLNSwe6HFajq06E3uo/Zdvii
 yBZICUraYRoA==
X-IronPort-AV: E=Sophos;i="5.75,312,1589241600"; 
   d="scan'208";a="56011891"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Jul 2020 15:06:15 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 4D1EAA2523;
        Sat,  4 Jul 2020 15:06:14 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:06:13 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.100) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:06:04 +0000
Subject: Re: [PATCH v4 05/18] nitro_enclaves: Handle PCI device command
 requests
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, kbuild test robot <lkp@intel.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-6-andraprs@amazon.com>
 <7a0b3e10-8760-db9c-37a3-aadbb7a042de@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <525958ac-c244-612b-daa3-c34f89a0e2c6@amazon.com>
Date:   Sat, 4 Jul 2020 18:05:58 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7a0b3e10-8760-db9c-37a3-aadbb7a042de@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D38UWC003.ant.amazon.com (10.43.162.23) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/07/2020 18:19, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> The Nitro Enclaves PCI device exposes a MMIO space that this driver
>> uses to submit command requests and to receive command replies e.g. for
>> enclave creation / termination or setting enclave resources.
>>
>> Add logic for handling PCI device command requests based on the given
>> command type.
>>
>> Register an MSI-X interrupt vector for command reply notifications to
>> handle this type of communication events.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>
>> Fix issue reported in:
>> https://lore.kernel.org/lkml/202004231644.xTmN4Z1z%25lkp@intel.com/
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Use dev_err instead of custom NE log pattern.
>> * Return IRQ_NONE when interrupts are not handled.
>>
>> v2 -> v3
>>
>> * Remove the WARN_ON calls.
>> * Update static calls sanity checks.
>> * Remove "ratelimited" from the logs that are not in the ioctl call
>> =A0=A0 paths.
>>
>> v1 -> v2
>>
>> * Add log pattern for NE.
>> * Remove the BUG_ON calls.
>> * Update goto labels to match their purpose.
>> * Add fix for kbuild report.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_pci_dev.c | 232 +++++++++++++++++++++=
++
>> =A0 1 file changed, 232 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> index 235fa3ecbee2..c24230cfe7c0 100644
>> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> @@ -27,6 +27,218 @@ static const struct pci_device_id ne_pci_ids[] =3D {
>> =A0 =A0 MODULE_DEVICE_TABLE(pci, ne_pci_ids);
>> =A0 +/**
>> + * ne_submit_request - Submit command request to the PCI device =

>> based on the
>> + * command type.
>> + *
>> + * This function gets called with the ne_pci_dev mutex held.
>> + *
>> + * @pdev: PCI device to send the command to.
>> + * @cmd_type: command type of the request sent to the PCI device.
>> + * @cmd_request: command request payload.
>> + * @cmd_request_size: size of the command request payload.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_submit_request(struct pci_dev *pdev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum ne_pci_dev_cmd_ty=
pe cmd_type,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 void *cmd_request, siz=
e_t cmd_request_size)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +
>> +=A0=A0=A0 if (!ne_pci_dev || !ne_pci_dev->iomem_base)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> How can this ever happen?

Removed this one and the next checks in v5 of the patch series.

Thanks,
Andra

>
>> +
>> +=A0=A0=A0 memcpy_toio(ne_pci_dev->iomem_base + NE_SEND_DATA, cmd_reques=
t,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd_request_size);
>> +
>> +=A0=A0=A0 iowrite32(cmd_type, ne_pci_dev->iomem_base + NE_COMMAND);
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/**
>> + * ne_retrieve_reply - Retrieve reply from the PCI device.
>> + *
>> + * This function gets called with the ne_pci_dev mutex held.
>> + *
>> + * @pdev: PCI device to receive the reply from.
>> + * @cmd_reply: command reply payload.
>> + * @cmd_reply_size: size of the command reply payload.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_retrieve_reply(struct pci_dev *pdev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ne_pci_dev_cmd_=
reply *cmd_reply,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t cmd_reply_size)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +
>> +=A0=A0=A0 if (!ne_pci_dev || !ne_pci_dev->iomem_base)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> Same.
>
>> +
>> +=A0=A0=A0 memcpy_fromio(cmd_reply, ne_pci_dev->iomem_base + NE_RECV_DAT=
A,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd_reply_size);
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/**
>> + * ne_wait_for_reply - Wait for a reply of a PCI command.
>> + *
>> + * This function gets called with the ne_pci_dev mutex held.
>> + *
>> + * @pdev: PCI device for which a reply is waited.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_wait_for_reply(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +=A0=A0=A0 int rc =3D -EINVAL;
>
> Unused assignment?
>
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> Same.
>
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * TODO: Update to _interruptible and handle interrupted wa=
it event
>> +=A0=A0=A0=A0 * e.g. -ERESTARTSYS, incoming signals + add / update timeo=
ut.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 rc =3D wait_event_timeout(ne_pci_dev->cmd_reply_wait_q,
>> + atomic_read(&ne_pci_dev->cmd_reply_avail) !=3D 0,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 msecs_to_jiffies(NE_DEFAU=
LT_TIMEOUT_MSECS));
>> +=A0=A0=A0 if (!rc)
>> +=A0=A0=A0=A0=A0=A0=A0 return -ETIMEDOUT;
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type =

>> cmd_type,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0 void *cmd_request, size_t cmd_request_size,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ne_pci_dev_cmd_reply *cmd_reply, siz=
e_t =

>> cmd_reply_size)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D NULL;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!pdev)
>> +=A0=A0=A0=A0=A0=A0=A0 return -ENODEV;
>
> When can this happen?
>
>> +
>> +=A0=A0=A0 ne_pci_dev =3D pci_get_drvdata(pdev);
>> +=A0=A0=A0 if (!ne_pci_dev || !ne_pci_dev->iomem_base)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> Same
>
>> +
>> +=A0=A0=A0 if (cmd_type <=3D INVALID_CMD || cmd_type >=3D MAX_CMD) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev, "Invalid cmd type=
=3D%u\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd_type);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (!cmd_request) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev, "Null cmd request=
\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (cmd_request_size > NE_SEND_DATA_SIZE) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Invalid req =
size=3D%zu for cmd type=3D%u\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd_request_s=
ize, cmd_type);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (!cmd_reply) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev, "Null cmd reply\n=
");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 if (cmd_reply_size > NE_RECV_DATA_SIZE) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev, "Invalid reply si=
ze=3D%zu\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd_reply_siz=
e);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Use this mutex so that the PCI device handles one comman=
d =

>> request at
>> +=A0=A0=A0=A0 * a time.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 mutex_lock(&ne_pci_dev->pci_dev_mutex);
>> +
>> +=A0=A0=A0 atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
>> +
>> +=A0=A0=A0 rc =3D ne_submit_request(pdev, cmd_type, cmd_request, =

>> cmd_request_size);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in sub=
mit request [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D ne_wait_for_reply(pdev);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in wai=
t for reply [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in ret=
rieve reply [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
>> +
>> +=A0=A0=A0 if (cmd_reply->rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(&pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in cmd=
 process logic [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd_reply->rc=
);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D cmd_reply->rc;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto unlock_mutex;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_pci_dev->pci_dev_mutex);
>> +
>> +=A0=A0=A0 return 0;
>
> Can you just set rc to 0 and fall through?

Done.

>
>> +
>> +unlock_mutex:
>> +=A0=A0=A0 mutex_unlock(&ne_pci_dev->pci_dev_mutex);
>> +
>> +=A0=A0=A0 return rc;
>> +}
>> +
>> +/**
>> + * ne_reply_handler - Interrupt handler for retrieving a reply matching
>> + * a request sent to the PCI device for enclave lifetime management.
>> + *
>> + * @irq: received interrupt for a reply sent by the PCI device.
>> + * @args: PCI device private data structure.
>> + *
>> + * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
>> + */
>> +static irqreturn_t ne_reply_handler(int irq, void *args)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D (struct ne_pci_dev *)args;
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return IRQ_NONE;
>
> How can this ever happen?
>
>
> Alex
>
>> +
>> +=A0=A0=A0 atomic_set(&ne_pci_dev->cmd_reply_avail, 1);
>> +
>> +=A0=A0=A0 /* TODO: Update to _interruptible. */
>> +=A0=A0=A0 wake_up(&ne_pci_dev->cmd_reply_wait_q);
>> +
>> +=A0=A0=A0 return IRQ_HANDLED;
>> +}
>> +
>> =A0 /**
>> =A0=A0 * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>> =A0=A0 *
>> @@ -59,7 +271,25 @@ static int ne_setup_msix(struct pci_dev *pdev)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;
>> =A0=A0=A0=A0=A0 }
>> =A0 +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * This IRQ gets triggered every time the PCI device respon=
ds to a
>> +=A0=A0=A0=A0 * command request. The reply is then retrieved, reading fr=
om =

>> the MMIO
>> +=A0=A0=A0=A0 * space of the PCI device.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 rc =3D request_irq(pci_irq_vector(pdev, NE_VEC_REPLY),
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_reply_handler, 0, "enclave_cmd"=
, ne_pci_dev);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in request irq reply [=
rc=3D%d]\n", =

>> rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_irq_vectors;
>> +=A0=A0=A0 }
>> +
>> =A0=A0=A0=A0=A0 return 0;
>> +
>> +free_irq_vectors:
>> +=A0=A0=A0 pci_free_irq_vectors(pdev);
>> +
>> +=A0=A0=A0 return rc;
>> =A0 }
>> =A0 =A0 /**
>> @@ -74,6 +304,8 @@ static void ne_teardown_msix(struct pci_dev *pdev)
>> =A0=A0=A0=A0=A0 if (!ne_pci_dev)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>> =A0 +=A0=A0=A0 free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>> +
>> =A0=A0=A0=A0=A0 pci_free_irq_vectors(pdev);
>> =A0 }
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

