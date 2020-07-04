Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C5F2146FC
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 17:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgGDPn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 11:43:28 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64804 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgGDPn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 11:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593877406; x=1625413406;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=n2dWr7gm9H7OUjK09qHgnMN5WT5OD5pPnkAXz3ZiBaU=;
  b=F7Nif+jJpIu2w9MLX2MUED8FBjJIE8/GW+08OVuaZbdfonbe/FpoeUSD
   Qw5JTxyTGHDHKDDnUxgkBLsHVveGiFInDnUabJ2B4goVz0uyoOCx8Ax9Z
   YOJ8R4wTTISx8fPSULGAv14O6K7CncxlWYKwb8gvLKooSywUJSoN/QR7z
   0=;
IronPort-SDR: vvTuIuFDl5r/cTkYtiJkATQ043ltuAmqvaxQkIS5WF0gcyHyfoNEaC2byrcD5n/2sprJDIe8LV
 3qkcRDh0zYVw==
X-IronPort-AV: E=Sophos;i="5.75,312,1589241600"; 
   d="scan'208";a="57284908"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Jul 2020 15:43:21 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 956CBA205F;
        Sat,  4 Jul 2020 15:43:18 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:43:17 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.140) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 15:43:09 +0000
Subject: Re: [PATCH v4 06/18] nitro_enclaves: Handle out-of-band PCI device
 events
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
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-7-andraprs@amazon.com>
 <82768612-0d23-55a9-dedf-58ade57b37af@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <96667e27-3379-4817-843f-988af9db4366@amazon.com>
Date:   Sat, 4 Jul 2020 18:43:04 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <82768612-0d23-55a9-dedf-58ade57b37af@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D08UWB002.ant.amazon.com (10.43.161.168) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/07/2020 18:24, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> In addition to the replies sent by the Nitro Enclaves PCI device in
>> response to command requests, out-of-band enclave events can happen e.g.
>> an enclave crashes. In this case, the Nitro Enclaves driver needs to be
>> aware of the event and notify the corresponding user space process that
>> abstracts the enclave.
>>
>> Register an MSI-X interrupt vector to be used for this kind of
>> out-of-band events. The interrupt notifies that the state of an enclave
>> changed and the driver logic scans the state of each running enclave to
>> identify for which this notification is intended.
>>
>> Create an workqueue to handle the out-of-band events. Notify user space
>> enclave process that is using a polling mechanism on the enclave fd.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
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
>> * Update goto labels to match their purpose.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_pci_dev.c | 122 +++++++++++++++++++++=
++
>> =A0 1 file changed, 122 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> index c24230cfe7c0..9a137862cade 100644
>> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> @@ -239,6 +239,93 @@ static irqreturn_t ne_reply_handler(int irq, =

>> void *args)
>> =A0=A0=A0=A0=A0 return IRQ_HANDLED;
>> =A0 }
>> =A0 +/**
>> + * ne_event_work_handler - Work queue handler for notifying enclaves on
>> + * a state change received by the event interrupt handler.
>> + *
>> + * An out-of-band event is being issued by the Nitro Hypervisor when =

>> at least
>> + * one enclave is changing state without client interaction.
>> + *
>> + * @work: item containing the Nitro Enclaves PCI device for which a
>> + *=A0=A0=A0=A0=A0 out-of-band event was issued.
>> + */
>> +static void ne_event_work_handler(struct work_struct *work)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev_cmd_reply cmd_reply =3D {};
>> +=A0=A0=A0 struct ne_enclave *ne_enclave =3D NULL;
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D
>> +=A0=A0=A0=A0=A0=A0=A0 container_of(work, struct ne_pci_dev, notify_work=
);
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +=A0=A0=A0 struct slot_info_req slot_info_req =3D {};
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>
> How?

Removed this check and the one below. Thank you.

Andra

>
>> +
>> +=A0=A0=A0 mutex_lock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * Iterate over all enclaves registered for the Nitro Encla=
ves
>> +=A0=A0=A0=A0 * PCI device and determine for which enclave(s) the out-of=
-band =

>> event
>> +=A0=A0=A0=A0 * is corresponding to.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 list_for_each_entry(ne_enclave, &ne_pci_dev->enclaves_list,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enclave_list_entry) {
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 /*
>> +=A0=A0=A0=A0=A0=A0=A0=A0 * Enclaves that were never started cannot rece=
ive out-of-band
>> +=A0=A0=A0=A0=A0=A0=A0=A0 * events.
>> +=A0=A0=A0=A0=A0=A0=A0=A0 */
>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_enclave->state !=3D NE_STATE_RUNNING)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unlock;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 slot_info_req.slot_uid =3D ne_enclave->slot_uid;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_do_request(ne_enclave->pdev, SLOT_INFO,=
 &slot_info_req,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(slot_info=
_req), &cmd_reply,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(cmd_reply=
));
>> +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err(&ne_enclave->pdev->dev,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in slot info [rc=
=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 /* Notify enclave process that the enclave state =
changed. */
>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_enclave->state !=3D cmd_reply.state) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_enclave->state =3D cmd_reply.state;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_enclave->has_event =3D true;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wake_up_interruptible(&ne_enclave->ev=
entq);
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +unlock:
>> +=A0=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
>> +}
>> +
>> +/**
>> + * ne_event_handler - Interrupt handler for PCI device out-of-band
>> + * events. This interrupt does not supply any data in the MMIO region.
>> + * It notifies a change in the state of any of the launched enclaves.
>> + *
>> + * @irq: received interrupt for an out-of-band event.
>> + * @args: PCI device private data structure.
>> + *
>> + * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
>> + */
>> +static irqreturn_t ne_event_handler(int irq, void *args)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D (struct ne_pci_dev *)args;
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return IRQ_NONE;
>
> How can this happen?
>
>
> Alex
>
>> +
>> +=A0=A0=A0 queue_work(ne_pci_dev->event_wq, &ne_pci_dev->notify_work);
>> +
>> +=A0=A0=A0 return IRQ_HANDLED;
>> +}
>> +
>> =A0 /**
>> =A0=A0 * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>> =A0=A0 *
>> @@ -284,8 +371,37 @@ static int ne_setup_msix(struct pci_dev *pdev)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 goto free_irq_vectors;
>> =A0=A0=A0=A0=A0 }
>> =A0 +=A0=A0=A0 ne_pci_dev->event_wq =3D =

>> create_singlethread_workqueue("ne_pci_dev_wq");
>> +=A0=A0=A0 if (!ne_pci_dev->event_wq) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D -ENOMEM;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Cannot get wq for dev events=
 [rc=3D%d]\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto free_reply_irq_vec;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 INIT_WORK(&ne_pci_dev->notify_work, ne_event_work_handler);
>> +
>> +=A0=A0=A0 /*
>> +=A0=A0=A0=A0 * This IRQ gets triggered every time any enclave's state =

>> changes. Its
>> +=A0=A0=A0=A0 * handler then scans for the changes and propagates them t=
o the =

>> user
>> +=A0=A0=A0=A0 * space.
>> +=A0=A0=A0=A0 */
>> +=A0=A0=A0 rc =3D request_irq(pci_irq_vector(pdev, NE_VEC_EVENT),
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ne_event_handler, 0, "enclave_evt"=
, ne_pci_dev);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in request irq event [=
rc=3D%d]\n", =

>> rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 goto destroy_wq;
>> +=A0=A0=A0 }
>> +
>> =A0=A0=A0=A0=A0 return 0;
>> =A0 +destroy_wq:
>> +=A0=A0=A0 destroy_workqueue(ne_pci_dev->event_wq);
>> +free_reply_irq_vec:
>> +=A0=A0=A0 free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>> =A0 free_irq_vectors:
>> =A0=A0=A0=A0=A0 pci_free_irq_vectors(pdev);
>> =A0 @@ -304,6 +420,12 @@ static void ne_teardown_msix(struct pci_dev =

>> *pdev)
>> =A0=A0=A0=A0=A0 if (!ne_pci_dev)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>> =A0 +=A0=A0=A0 free_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_pci_dev);
>> +
>> +=A0=A0=A0 flush_work(&ne_pci_dev->notify_work);
>> +=A0=A0=A0 flush_workqueue(ne_pci_dev->event_wq);
>> +=A0=A0=A0 destroy_workqueue(ne_pci_dev->event_wq);
>> +
>> =A0=A0=A0=A0=A0 free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>> =A0 =A0=A0=A0=A0=A0 pci_free_irq_vectors(pdev);
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

