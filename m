Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B608F16C16E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgBYMxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:53:23 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:30314 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgBYMxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 07:53:23 -0500
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PCDs6Z017626;
        Tue, 25 Feb 2020 04:19:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=HMbTXtHYONqBon+DtOChGotJyhpi7mA9ZFTfZYEf5r8=;
 b=0A7ZFaAGu4c0SwUoppjTbS7QsKm1BFcNNSc71Q/ixVOLxHI3ftmiF+e/bn1TGzn6D1UJ
 j2QVOwJNlZGg/ETnhHWd+OPCMihNAP3nVyplT9l8JBYYx/fz0MzyeSuqE2m3zPCesjck
 pSFHo2OLvq05IUmREQ+xzI14nDokKPHmig9ly9Yuk7Ci+KzWI8MmI8/o6WpW+reCtyUt
 V4UCBggT6fi/n5EV8uxu0DqTGuOeCnSPtDhvZrbWHxCBRcY92kmQFN4BokTv0abhKGoZ
 Ld1OXHzCY6wFe8h2UgvTm3XgvpAcfKq+dG/a4yh0989LO0Fqz0Fmw3eM4Du5Hr+Ge7OY Ew== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0b-002c1b01.pphosted.com with ESMTP id 2yb4gmp3bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Feb 2020 04:19:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQ+g3EHEzhAzmP6KU8JOEmJoFc1z8Psaa+oiX8//Fd7Mn3Ie2h+gIsWVHN/JaiRjfLdayP1TaWytGlH0rmB+Lida2PTPdP9SsuEKmDMAR4GG1C1aQm0ULARNUNNByyhTXEl0wGY0nkO/fhu4XW6wVx/GIAk+/UEo1XPtRX7aXKhhIQc1nXukpQz2ta7GCog0XW5l5p6rFQpK+ahWLaub4R+vjIgAkNQYSIlCExJcmZ1tKRzSZ4KJthgAlufdoCAmoUaY0JVTeZYCgmvEo143s6XIPSk69a3VVucY/bs877rAHkXkC8r7FHUgnmY3QrjSZ8jy+RbKKwq8A9F/6+Xrng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMbTXtHYONqBon+DtOChGotJyhpi7mA9ZFTfZYEf5r8=;
 b=HQWZ2Q2G4L3Kw1K58g8TVbl3Hvs9jVoZdtaMCiaUC1oeqVy+MQVDVyxPAdEhRmA5naYkw8cSkZuCsXXqh5TIRrZuf3YLzoui0vJ+BSuyqtxefyix/PSMbwYAXiVDqnE6J7KYvU7Q/jiJ8sWSiIeZjtpcq010NfuRG4Rgulzu7B7npQrpF7umt8yfuuqVZvMHs7FPLamHdJ+jU9fhhoa49mMazqo+IKSmRQhbhgON6EUKeiONi3VN9yMP8EmnWVhWwZ4m1SJya2HmVBenbZgocuj3qXcJ7xgcRtAwkrwIl2Qlwuf9tU32eVEH65JQqexXeBer6ZgI7VjYIwYs0OorFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from MWHPR02MB2656.namprd02.prod.outlook.com (2603:10b6:300:45::14)
 by MWHPR02MB2430.namprd02.prod.outlook.com (2603:10b6:300:41::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Tue, 25 Feb
 2020 12:19:56 +0000
Received: from MWHPR02MB2656.namprd02.prod.outlook.com
 ([fe80::c4c8:b406:7827:8a2b]) by MWHPR02MB2656.namprd02.prod.outlook.com
 ([fe80::c4c8:b406:7827:8a2b%6]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 12:19:56 +0000
From:   Felipe Franciosi <felipe@nutanix.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "slp@redhat.com" <slp@redhat.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        "robert.bradford@intel.com" <robert.bradford@intel.com>,
        Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Thread-Topic: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Thread-Index: AQHV6b17a68gHQDa0EyXI0dJY95wc6gr2EuA
Date:   Tue, 25 Feb 2020 12:19:55 +0000
Message-ID: <62FEFA1E-0D75-4AFB-860A-59CF5B9B45F7@nutanix.com>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
In-Reply-To: <20200222201916.GA1763717@stefanha-x1.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [62.254.189.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a54a094b-bc27-4656-f36c-08d7b9ed0661
x-ms-traffictypediagnostic: MWHPR02MB2430:
x-microsoft-antispam-prvs: <MWHPR02MB24308C0229CD201B58C0F510D7ED0@MWHPR02MB2430.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(478600001)(2906002)(2616005)(186003)(5660300002)(66946007)(64756008)(6486002)(66446008)(8936002)(76116006)(66476007)(66556008)(30864003)(71200400001)(53546011)(91956017)(7416002)(26005)(6512007)(6506007)(81156014)(33656002)(316002)(81166006)(54906003)(8676002)(4326008)(36756003)(86362001)(6916009)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR02MB2430;H:MWHPR02MB2656.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nutanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kjuoiyPaDQbSb4WdsPFGxS9NepqvmWNeafpHepLREPAzFoGAGjeguflsV+9ibeQTlGgdHeCWV9Y3d53B/+y3TpfmU9AiEhWiFin+z3ld/8K4Li0464+j13p2HVM0yQxnTtcBj5MSyPdpoC2h2rX2SjyMUZ9e6zo9s7/xg6RYf6/LaKUp+veK5xLZNdmTkaRiMuoikCxB8oZWCZUoPP14UoY7OMtlY3Zd+TnzYdD0VOAX8yVgnJ5widuhLRjEhOlcV0pEYa2YGNBbGroPk6TQgP+VoOpyVChl16oP3A6gLQUqV7pMjEM7kTaGJsJ1yDZN+UPBGbn4pjZJ0J3xu2jegVBnEH8DNnITIs1oiiih6aUt6kQJkVAN7V9E6AW4qfxVfecrAG+vxCT593cSUGUh3dKP5KTsbybssEvXbfEYVVW9CSQ1PPESXPAw500WpehGF6kANWBdDXk9O326SyovjLOrC2kxVVlAgM+qcCxkwKxrccyutvocHraOMRQEDMov
x-ms-exchange-antispam-messagedata: rVch+onMcW3aTrG25C5eLXlyH4+32X7N0sPFdi+U0mQZsxyt6eslPufK/A95psRN1Pf9dYotH6PNNS+VwpIeD8rrQoAfnnf7P3OmpCoCD7taOLVbU7cwAtLlZXqelNh4D0GNrB3uxa6jfw0DXzdT2w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <59886CE98FFA9649AC4D8263E91E2250@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54a094b-bc27-4656-f36c-08d7b9ed0661
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 12:19:55.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G2xvZxGUQzpIS+NekAx2mpGpdGGeX/7ueu08ilgOvaHk792jP4HwpYnlrsTX/DrdDJz8e5XTwB4eTn6yNlzI/G4FrzRyAf/W1Rc639ljBZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2430
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_03:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This looks amazing, Stefan. The lack of such a mechanism troubled us
during the development of MUSER and resulted in the slow-path we have
today for MMIO with register semantics (when writes cannot be
overwritten before the device emulator has a chance to process them).

I have added some comments inline, but wanted to first link your
proposal with an idea that I discussed with Maxim Levitsky back in
Lyon and evolve on it a little bit. IIRC/IIUC Maxim was keen on a VT-x
extension where a CPU could IPI another to handle events which would
normally cause a VMEXIT. That is probably more applicable to the
standard ioeventfd model, but it got me thinking about PML.

Bear with me. :)

In addition to an fd, which could be used for notifications only, the
wire protocol could append "struct ioregionfd_cmd"s (probably renamed
to drop "fd") to one or more pages (perhaps a ring buffer of sorts).

That would only work for writes; reads would still be synchronous.

The device emulator therefore doesn't have to respond to each write
command. It could process the whole lot whenever it gets around to it.
Most importantly (and linking back to the VT-x extension idea), maybe
we can avoid the VMEXIT altogether if the CPU could take care of
appending writes to that buffer. Thoughts?

> On Feb 22, 2020, at 8:19 PM, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> Hi,
> I wanted to share this idea with the KVM community and VMM developers.
> If this isn't relevant to you but you know someone who should
> participate, please feel free to add them :).
>=20
> The following is an outline of "ioregionfd", a cross between ioeventfd
> and KVM memory regions.  This mechanism would be helpful for VMMs that
> emulate devices in separate processes, muser/VFIO, and to address
> existing use cases that ioeventfd cannot handle.
>=20
> Background
> ----------
> There are currently two mechanisms for dispatching MMIO/PIO accesses in
> KVM: returning KVM_EXIT_MMIO/KVM_EXIT_IO from ioctl(KVM_RUN) and
> ioeventfd.  Some VMMs also use polling to avoid dispatching
> performance-critical MMIO/PIO accesses altogether.
>=20
> These mechanisms have shortcomings for VMMs that perform device
> emulation in separate processes (usually for increased security):
>=20
> 1. Only one process performs ioctl(KVM_RUN) for a vCPU, so that
>   mechanism is not available to device emulation processes.
>=20
> 2. ioeventfd does not store the value written.  This makes it unsuitable
>   for NVMe Submission Queue Tail Doorbell registers because the value
>   written is needed by the device emulation process, for example.
>   ioeventfd also does not support read operations.
>=20
> 3. Polling does not support computed read operations and only the latest
>   value written is available to the device emulation process
>   (intermediate values are overwritten if the guest performs multiple
>   accesses).
>=20
> Overview
> --------
> This proposal aims to address this gap through a wire protocol and a new
> KVM API for registering MMIO/PIO regions that use this alternative
> dispatch mechanism.
>=20
> The KVM API is used by the VMM to set up dispatch.  The wire protocol is
> used to dispatch accesses from KVM to the device emulation process.
>=20
> This new MMIO/PIO dispatch mechanism eliminates the need to return from
> ioctl(KVM_RUN) in the VMM and then exchange messages with a device
> emulation process.
>=20
> Inefficient dispatch to device processes today:
>=20
>   kvm.ko  <---ioctl(KVM_RUN)---> VMM <---messages---> device
>=20
> Direct dispatch with the new mechanism:
>=20
>   kvm.ko  <---ioctl(KVM_RUN)---> VMM
>     ^
>     `---new MMIO/PIO mechanism-> device
>=20
> Even single-process VMMs can take advantage of the new mechanism.  For
> example, QEMU's emulated NVMe storage controller can implement IOThread
> support.
>=20
> No constraint is placed on the device process architecture.  A single
> process could emulate all devices belonging to the guest, each device
> could be its own process, or something in between.
>=20
> Both ioeventfd and traditional KVM_EXIT_MMIO/KVM_EXIT_IO emulation
> continue to work alongside the new mechanism, but only one of them is
> used for any given guest address.
>=20
> KVM API
> -------
> The following new KVM ioctl is added:
>=20
> KVM_SET_IOREGIONFD
> Capability: KVM_CAP_IOREGIONFD
> Architectures: all
> Type: vm ioctl
> Parameters: struct kvm_ioregionfd (in)
> Returns: 0 on success, !0 on error
>=20
> This ioctl adds, modifies, or removes MMIO or PIO regions where guest
> accesses are dispatched through a given file descriptor instead of
> returning from ioctl(KVM_RUN) with KVM_EXIT_MMIO or KVM_EXIT_PIO.
>=20
> struct kvm_ioregionfd {
>    __u64 guest_physical_addr;
>    __u64 memory_size; /* bytes */
>    __s32 fd;
>    __u32 region_id;
>    __u32 flags;
>    __u8  pad[36];
> };
>=20
> /* for kvm_ioregionfd::flags */
> #define KVM_IOREGIONFD_PIO           (1u << 0)
> #define KVM_IOREGIONFD_POSTED_WRITES (1u << 1)
>=20
> Regions are deleted by passing zero for memory_size.
>=20
> MMIO is the default.  The KVM_IOREGIONFD_PIO flag selects PIO instead.
>=20
> The region_id is an opaque token that is included as part of the write
> to the file descriptor.  It is typically a unique identifier for this
> region but KVM does not interpret its value.
>=20
> Both read and write guest accesses wait until an acknowledgement is
> received on the file descriptor.  The KVM_IOREGIONFD_POSTED_WRITES flag
> skips waiting for an acknowledgement on write accesses.  This is
> suitable for accesses that do not require synchronous emulation, such as
> doorbell register writes.
>=20
> Wire protocol
> -------------
> The protocol spoken over the file descriptor is as follows.  The device
> reads commands from the file descriptor with the following layout:
>=20
> struct ioregionfd_cmd {
>    __u32 info;
>    __u32 region_id;
>    __u64 addr;
>    __u64 data;
>    __u8 pad[8];
> };
>=20
> /* for ioregionfd_cmd::info */
> #define IOREGIONFD_CMD_MASK 0xf
> # define IOREGIONFD_CMD_READ 0
> # define IOREGIONFD_CMD_WRITE 1

Why do we need 4 bits for this? I appreciate you want to align the
next field, but there's SIZE_SHIFT for that; you could have CMD_MASK
set to 0x1 unless I'm missing something. The reserved space could be
used for something else in the future.

> #define IOREGIONFD_SIZE_MASK 0x30
> #define IOREGIONFD_SIZE_SHIFT 4
> # define IOREGIONFD_SIZE_8BIT 0
> # define IOREGIONFD_SIZE_16BIT 1
> # define IOREGIONFD_SIZE_32BIT 2
> # define IOREGIONFD_SIZE_64BIT 3

Christophe already asked about the 64-bit limit. I think that's fine,
and am assuming that if larger accesses are ever needed they can just
be split in two commands by KVM?

> #define IOREGIONFD_NEED_PIO (1u << 6)
> #define IOREGIONFD_NEED_RESPONSE (1u << 7)
>=20
> The command is interpreted by inspecting the info field:
>=20
>  switch (cmd.info & IOREGIONFD_CMD_MASK) {
>  case IOREGIONFD_CMD_READ:
>      /* It's a read access */
>      break;
>  case IOREGIONFD_CMD_WRITE:
>      /* It's a write access */
>      break;
>  default:
>      /* Protocol violation, terminate connection */
>  }
>=20
> The access size is interpreted by inspecting the info field:
>=20
>  unsigned size =3D (cmd.info & IOREGIONFD_SIZE_MASK) >> IOREGIONFD_SIZE_S=
HIFT;
>  /* where nbytes =3D pow(2, size) */
>=20
> The region_id indicates which MMIO/PIO region is being accessed.  This
> field has no inherent structure but is typically a unique identifier.
>=20
> The byte offset being accessed within that region is addr.

It's not clear to me if addr is GPA absolute or an offset. Sounds like
the latter, in which case isn't it preferable to name this "offset"?

>=20
> If the command is IOREGIONFD_CMD_WRITE then data contains the value
> being written.
>=20
> MMIO is the default.  The IOREGIONFD_NEED_PIO flag is set on PIO
> accesses.
>=20
> When IOREGIONFD_NEED_RESPONSE is set on a IOREGIONFD_CMD_WRITE command,
> no response must be sent.  This flag has no effect for
> IOREGIONFD_CMD_READ commands.

Christophe already flagged this, too. :)

That's all I had for now.

F.

>=20
> The device sends responses by writing the following structure to the
> file descriptor:
>=20
> struct ioregionfd_resp {
>    __u64 data;
>    __u32 info;
>    __u8 pad[20];
> };
>=20
> /* for ioregionfd_resp::info */
> #define IOREGIONFD_RESP_FAILED (1u << 0)
>=20
> The info field is zero on success.  The IOREGIONFD_RESP_FAILED flag is
> set on failure.
>=20
> The data field contains the value read by an IOREGIONFD_CMD_READ
> command.  This field is zero for other commands.
>=20
> Does it support polling?
> ------------------------
> Yes, use io_uring's IORING_OP_READ to submit an asynchronous read on the
> file descriptor.  Poll the io_uring cq ring to detect when the read has
> completed.
>=20
> Although this dispatch mechanism incurs more overhead than polling
> directly on guest RAM, it overcomes the limitations of polling: it
> supports read accesses as well as capturing written values instead of
> overwriting them.
>=20
> Does it obsolete ioeventfd?
> ---------------------------
> No, although KVM_IOREGIONFD_POSTED_WRITES offers somewhat similar
> functionality to ioeventfd, there are differences.  The datamatch
> functionality of ioeventfd is not available and would need to be
> implemented by the device emulation program.  Due to the counter
> semantics of eventfds there is automatic coalescing of repeated accesses
> with ioeventfd.  Overall ioeventfd is lighter weight but also more
> limited.
>=20
> How does it scale?
> ------------------
> The protocol is synchronous - only one command/response cycle is in
> flight at a time.  The vCPU will be blocked until the response has been
> processed anyway.  If another vCPU accesses an MMIO or PIO region with
> the same file descriptor during this time then it will wait to.
>=20
> In practice this is not a problem since per-queue file descriptors can
> be set up for multi-queue devices.
>=20
> It is up to the device emulation program whether to handle multiple
> devices over the same file descriptor or not.
>=20
> What exactly is the file descriptor (e.g. eventfd, pipe, char device)?
> ----------------------------------------------------------------------
> Any file descriptor that supports bidirectional I/O would do.  This
> rules out eventfds and pipes.  socketpair(AF_UNIX) is a likely
> candidate.  Maybe a char device will be necessary for improved
> performance.
>=20
> Can this be part of KVM_SET_USER_MEMORY_REGION?
> -----------------------------------------------
> Maybe.  Perhaps everything can be squeezed into struct
> kvm_userspace_memory_region but it's only worth doing if the memory
> region code needs to be reused for this in the first place.  I'm not
> sure.
>=20
> What do you think?
> ------------------
> I hope this serves as a starting point for improved MMIO/PIO dispatch in
> KVM.  There are no immediate plans to implement this but I think it will
> become necessary within the next year or two.
>=20
> 1. Does it meet your requirements?
> 2. Are there better alternatives?
>=20
> Thanks,
> Stefan

