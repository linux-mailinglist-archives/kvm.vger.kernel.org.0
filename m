Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B62FE419
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfD2N6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 09:58:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfD2N6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 09:58:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TDrb8u102802;
        Mon, 29 Apr 2019 13:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to : content-transfer-encoding; s=corp-2018-07-02;
 bh=Gz6Ua/3GGNeg8lKwlMiyBYsmhe7CjbMRZf+NRa3oHPc=;
 b=WL+bY5sYu/gGn/l6x75MADFcvmJJSz6tGkmh2VZdzUswC8w/Xzkix/rLp5iEk0Pd8539
 fdcSKRBwYctVhDpHy7lQ05WaZYvX5szXP6yClsUrz34H6c41slLPm+BpSnmwdbcwxe+o
 dgvtuknnSdJlNejxftoc8FF61XweKVZ5dJTZ4Ws8aWwpuiF6LONUXLuaqxTIERwxKpG2
 C7CYxahZNQTQPthIDy0x+x6LNycaFoe/SzunExfO6rVfSuJ+79u/qT4u1W4r62k1sgGX
 LRiAtpU8qKiEpr6NKcVbDtpYtR3c+bkBRq+mO3VqLZq3PkYuH7/27ApXRO7rXq1ied7B bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s4fqpxgb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 13:58:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TDuxMk150317;
        Mon, 29 Apr 2019 13:58:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s5u50dvk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 13:58:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3TDwOfm002890;
        Mon, 29 Apr 2019 13:58:25 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 06:58:24 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 054AF6A010F; Mon, 29 Apr 2019 09:58:28 -0400 (EDT)
Date:   Mon, 29 Apr 2019 09:58:28 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     "Raslan, KarimAllah" <karahmed@amazon.de>, pbonzini@redhat.com
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 00/14] KVM/X86: Introduce a new guest mapping interface
Message-ID: <20190429135828.GA21193@char.us.oracle.com>
References: <1548966284-28642-1-git-send-email-karahmed@amazon.de>
 <1552914624.8242.1.camel@amazon.de>
 <20190318142232.GC16697@char.us.oracle.com>
 <1552936587.8242.22.camel@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1552936587.8242.22.camel@amazon.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9241 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904290099
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9241 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904290099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 18, 2019 at 07:16:28PM +0000, Raslan, KarimAllah wrote:
> On Mon, 2019-03-18 at 10:22 -0400, Konrad Rzeszutek Wilk wrote:
> > On Mon, Mar 18, 2019 at 01:10:24PM +0000, Raslan, KarimAllah wrote:
> > >=20
> > > I guess this patch series missed the 5.1 merge window? :)
> >=20
> > Were there any outstanding fixes that had to be addressed?
>=20
> Not as far as I can remember. This version addressed all requests raise=
d in=A0
> 'v5'.

Paolo,

Are there any concerns in pulling this patchset in?

Thank you!
>=20
> >=20
> > >=20
> > >=20
> > > On Thu, 2019-01-31 at 21:24 +0100, KarimAllah Ahmed wrote:
> > > >=20
> > > > Guest memory can either be directly managed by the kernel (i.e. h=
ave a "struct
> > > > page") or they can simply live outside kernel control (i.e. do no=
t have a
> > > > "struct page"). KVM mostly support these two modes, except in a f=
ew places
> > > > where the code seems to assume that guest memory must have a "str=
uct page".
> > > >=20
> > > > This patchset introduces a new mapping interface to map guest mem=
ory into host
> > > > kernel memory which also supports PFN-based memory (i.e. memory w=
ithout 'struct
> > > > page'). It also converts all offending code to this interface or =
simply
> > > > read/write directly from guest memory. Patch 2 is additionally fi=
xing an
> > > > incorrect page release and marking the page as dirty (i.e. as a s=
ide-effect of
> > > > using the helper function to write).
> > > >=20
> > > > As far as I can see all offending code is now fixed except the AP=
IC-access page
> > > > which I will handle in a seperate series along with dropping
> > > > kvm_vcpu_gfn_to_page and kvm_vcpu_gpa_to_page from the internal K=
VM API.
> > > >=20
> > > > The current implementation of the new API uses memremap to map me=
mory that does
> > > > not have a "struct page". This proves to be very slow for high fr=
equency
> > > > mappings. Since this does not affect the normal use-case where a =
"struct page"
> > > > is available, the performance of this API will be handled by a se=
perate patch
> > > > series.
> > > >=20
> > > > So the simple way to use memory outside kernel control is:
> > > >=20
> > > > 1- Pass 'mem=3D' in the kernel command-line to limit the amount o=
f memory managed=20
> > > >    by the kernel.
> > > > 2- Map this physical memory you want to give to the guest with:
> > > >    mmap("/dev/mem", physical_address_offset, ..)
> > > > 3- Use the user-space virtual address as the "userspace_addr" fie=
ld in
> > > >    KVM_SET_USER_MEMORY_REGION ioctl.
> > > >=20
> > > > v5 -> v6:
> > > > - Added one extra patch to ensure that support for this mem=3D ca=
se is complete
> > > >   for x86.
> > > > - Added a helper function to check if the mapping is mapped or no=
t.
> > > > - Added more comments on the struct.
> > > > - Setting ->page to NULL on unmap and to a poison ptr if unused d=
uring map
> > > > - Checking for map ptr before using it.
> > > > - Change kvm_vcpu_unmap to also mark page dirty for LM. That requ=
ires
> > > >   passing the vCPU pointer again to this function.
> > > >=20
> > > > v4 -> v5:
> > > > - Introduce a new parameter 'dirty' into kvm_vcpu_unmap
> > > > - A horrible rebase due to nested.c :)
> > > > - Dropped a couple of hyperv patches as the code was fixed alread=
y as a
> > > >   side-effect of another patch.
> > > > - Added a new trivial cleanup patch.
> > > >=20
> > > > v3 -> v4:
> > > > - Rebase
> > > > - Add a new patch to also fix the newly introduced enlightned VMC=
S.
> > > >=20
> > > > v2 -> v3:
> > > > - Rebase
> > > > - Add a new patch to also fix the newly introduced shadow VMCS.
> > > >=20
> > > > Filippo Sironi (1):
> > > >   X86/KVM: Handle PFNs outside of kernel reach when touching GPTE=
s
> > > >=20
> > > > KarimAllah Ahmed (13):
> > > >   X86/nVMX: handle_vmon: Read 4 bytes from guest memory
> > > >   X86/nVMX: Update the PML table without mapping and unmapping th=
e page
> > > >   KVM: Introduce a new guest mapping API
> > > >   X86/nVMX: handle_vmptrld: Use kvm_vcpu_map when copying VMCS12 =
from
> > > >     guest memory
> > > >   KVM/nVMX: Use kvm_vcpu_map when mapping the L1 MSR bitmap
> > > >   KVM/nVMX: Use kvm_vcpu_map when mapping the virtual APIC page
> > > >   KVM/nVMX: Use kvm_vcpu_map when mapping the posted interrupt
> > > >     descriptor table
> > > >   KVM/X86: Use kvm_vcpu_map in emulator_cmpxchg_emulated
> > > >   KVM/nSVM: Use the new mapping API for mapping guest memory
> > > >   KVM/nVMX: Use kvm_vcpu_map for accessing the shadow VMCS
> > > >   KVM/nVMX: Use kvm_vcpu_map for accessing the enlightened VMCS
> > > >   KVM/nVMX: Use page_address_valid in a few more locations
> > > >   kvm, x86: Properly check whether a pfn is an MMIO or not
> > > >=20
> > > >  arch/x86/include/asm/e820/api.h |   1 +
> > > >  arch/x86/kernel/e820.c          |  18 ++++-
> > > >  arch/x86/kvm/mmu.c              |   5 +-
> > > >  arch/x86/kvm/paging_tmpl.h      |  38 +++++++---
> > > >  arch/x86/kvm/svm.c              |  97 ++++++++++++------------
> > > >  arch/x86/kvm/vmx/nested.c       | 160 +++++++++++++++-----------=
--------------
> > > >  arch/x86/kvm/vmx/vmx.c          |  19 ++---
> > > >  arch/x86/kvm/vmx/vmx.h          |   9 ++-
> > > >  arch/x86/kvm/x86.c              |  14 ++--
> > > >  include/linux/kvm_host.h        |  28 +++++++
> > > >  virt/kvm/kvm_main.c             |  64 ++++++++++++++++
> > > >  11 files changed, 267 insertions(+), 186 deletions(-)
> > > >=20
> > >=20
> > >=20
> > >=20
> > > Amazon Development Center Germany GmbH
> > > Krausenstr. 38
> > > 10117 Berlin
> > > Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
> > > Ust-ID: DE 289 237 879
> > > Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
> > >=20
>=20
>=20
>=20
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
> Ust-ID: DE 289 237 879
> Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
>=20
