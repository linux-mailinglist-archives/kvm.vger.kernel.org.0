Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE618C497
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 02:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgCTBVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 21:21:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6418 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgCTBVJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 21:21:09 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K15LLM135315
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 21:21:09 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu933mt25-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 21:21:08 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <linuxram@us.ibm.com>;
        Fri, 20 Mar 2020 01:21:07 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Mar 2020 01:21:04 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02K1L3gp46530852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 01:21:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4350A11C050;
        Fri, 20 Mar 2020 01:21:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 389CD11C052;
        Fri, 20 Mar 2020 01:21:02 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.165.102])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 20 Mar 2020 01:21:02 +0000 (GMT)
Date:   Thu, 19 Mar 2020 18:20:59 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20200319043301.GA13052@blackberry>
 <20200319194108.GB5563@oc0525413822.ibm.com>
 <20200319231713.GA3260@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319231713.GA3260@blackberry>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20032001-4275-0000-0000-000003AF684D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032001-4276-0000-0000-000038C4982F
Message-Id: <20200320012059.GC5563@oc0525413822.ibm.com>
Subject: RE: [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling secure
 guests
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=2 priorityscore=1501 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200003
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 10:17:13AM +1100, Paul Mackerras wrote:
> On Thu, Mar 19, 2020 at 12:41:08PM -0700, Ram Pai wrote:
> > On Thu, Mar 19, 2020 at 03:33:01PM +1100, Paul Mackerras wrote:
> [snip]
> > > --- a/arch/powerpc/kvm/powerpc.c
> > > +++ b/arch/powerpc/kvm/powerpc.c
> > > @@ -670,6 +670,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > >  		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
> > >  		break;
> > >  #endif
> > > +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
> > > +	case KVM_CAP_PPC_SECURE_GUEST:
> > > +		r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR);
> > 
> > We also need to check if the kvmppc_uvmem_init() has been successfully
> > called and initialized.
> > 
> > 	r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR)
> > 		&& kvmppc_uvmem_bitmap;
> 
> Well I can't do that exactly because kvmppc_uvmem_bitmap is in a
> different module (the kvm_hv module, whereas this code is in the kvm
> module), and I wouldn't want to depend on kvmppc_uvmem_bitmap, since
> that's an internal implementation detail.

yes. checking for kvmppc_uvmem_bitmap depends on internal implementation
detail. Its also a loose approximation.  There has to be something
better which can tell, if everything needed to support secure guests, is
available and initialized.

> 
> The firmware_has_feature(FW_FEATURE_ULTRAVISOR) test ultimately
> depends on there being a device tree node with "ibm,ultravisor" in its
> compatible property (see early_init_dt_scan_ultravisor()).  So that
> means there is an ultravisor there.  The cases where that test would
> pass but kvmppc_uvmem_bitmap == NULL would be those where the device
> tree nodes are present but not right, or where the host is so short of
> memory that it couldn't allocate the kvmppc_uvmem_bitmap.  If you
> think those cases are worth worrying about then I will have to devise
> a way to do the test without depending on any symbols from the kvm-hv
> module.

the cases, where incorrect behavior can happen; if we do not have this additional
check, are --

a) zero secure memory in the system.
b) "kvmppc_uvmem" memory region is not defined.
c) the memory region fails to map.
d) kvmppc_uvmem_bitmap allocation failed.

All these are possible to varying level of certainity.

I do not know we should be concerned about these possibilities.
But if we do, than will a patch like this help? compile tested.

------------------
diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index 5a9834e..643c497 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -4,6 +4,7 @@
 
 #ifdef CONFIG_PPC_UV
 int kvmppc_uvmem_init(void);
+int kvmppc_uv_enabled(void);
 void kvmppc_uvmem_free(void);
 int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot);
 void kvmppc_uvmem_slot_free(struct kvm *kvm,
@@ -28,6 +29,11 @@ static inline int kvmppc_uvmem_init(void)
 	return 0;
 }
 
+static inline int kvmppc_uv_enabled(void)
+{
+	return 0;
+}
+
 static inline void kvmppc_uvmem_free(void) { }
 
 static inline int
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 79b1202..3331ac5 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -804,6 +804,11 @@ int kvmppc_uvmem_init(void)
 	return ret;
 }
 
+int kvmppc_uv_enabled(void)
+{
+	return !kvmppc_uvmem_bitmap;
+}
+
 void kvmppc_uvmem_free(void)
 {
 	memunmap_pages(&kvmppc_uvmem_pgmap);
------------------

> 
> Paul.

-- 
Ram Pai

