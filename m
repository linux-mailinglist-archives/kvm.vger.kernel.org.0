Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01646133E7
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfECTLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 15:11:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfECTLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 15:11:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43J9QVY072392;
        Fri, 3 May 2019 19:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=a86vxDAMmDZunhpHy82/NG4lJq3xoayrJQUovklZnbM=;
 b=GUaj0gn+6Hne4WcDc2+MycuEIH9NmcrDxBxTFdmcpjqQUuQMrKZCuoN3p7c8aOuu/oQG
 Hj4dxbkyH4v7q6B9HQCYW/tssbteAYl3MjIf3SdgBMcGstfwF4tmsXEe6bDV4Cm9Q83W
 bExJT09glgqepPb0IJ3WV6laCENPZ+sI/BOBElzvULwKupZcywRAvr75qM/y0tpit89r
 +PpNpjpC7btc3sUCQGvZqIZ6p2q2AdWgdP7vjqH+3LtAgT/sqtoV/xMF42HS6I9X3wA0
 zoWznpCHwxnQw0cMBSkZcn0HBJqmZEaRsR5Fv/X0vBkNiJa5mfxlWL/GHuVIxYV36Pmr ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s6xj00qtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:11:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43JB9wI058321;
        Fri, 3 May 2019 19:11:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s6xhhss65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:11:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43JBFEp019311;
        Fri, 3 May 2019 19:11:16 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 12:11:15 -0700
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86: Remove redeundant page zeroing
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
 <20190503103207.9021-3-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <2929d3d2-6d24-2996-13b3-8809c242002d@oracle.com>
Date:   Fri, 3 May 2019 12:11:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190503103207.9021-3-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/03/2019 03:32 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> Now that alloc_page() zeros the page, remove the redundant page zeroing.
>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/x86/intel-iommu.c    |  5 -----
>   x86/eventinj.c           |  1 -
>   x86/hyperv_connections.c |  4 ----
>   x86/vmx.c                | 10 ----------
>   x86/vmx_tests.c          | 11 -----------
>   5 files changed, 31 deletions(-)
>
> diff --git a/lib/x86/intel-iommu.c b/lib/x86/intel-iommu.c
> index 3f3f211..c811ba5 100644
> --- a/lib/x86/intel-iommu.c
> +++ b/lib/x86/intel-iommu.c
> @@ -125,7 +125,6 @@ static void vtd_setup_root_table(void)
>   {
>   	void *root = alloc_page();
>   
> -	memset(root, 0, PAGE_SIZE);
>   	vtd_writeq(DMAR_RTADDR_REG, virt_to_phys(root));
>   	vtd_gcmd_or(VTD_GCMD_ROOT);
>   	printf("DMAR table address: %#018lx\n", vtd_root_table());
> @@ -135,7 +134,6 @@ static void vtd_setup_ir_table(void)
>   {
>   	void *root = alloc_page();
>   
> -	memset(root, 0, PAGE_SIZE);
>   	/* 0xf stands for table size (2^(0xf+1) == 65536) */
>   	vtd_writeq(DMAR_IRTA_REG, virt_to_phys(root) | 0xf);
>   	vtd_gcmd_or(VTD_GCMD_IR_TABLE);
> @@ -153,7 +151,6 @@ static void vtd_install_pte(vtd_pte_t *root, iova_t iova,
>   		offset = PGDIR_OFFSET(iova, level);
>   		if (!(root[offset] & VTD_PTE_RW)) {
>   			page = alloc_page();
> -			memset(page, 0, PAGE_SIZE);
>   			root[offset] = virt_to_phys(page) | VTD_PTE_RW;
>   		}
>   		root = (uint64_t *)(phys_to_virt(root[offset] &
> @@ -195,7 +192,6 @@ void vtd_map_range(uint16_t sid, iova_t iova, phys_addr_t pa, size_t size)
>   
>   	if (!re->present) {
>   		ce = alloc_page();
> -		memset(ce, 0, PAGE_SIZE);
>   		memset(re, 0, sizeof(*re));
>   		re->context_table_p = virt_to_phys(ce) >> VTD_PAGE_SHIFT;
>   		re->present = 1;
> @@ -209,7 +205,6 @@ void vtd_map_range(uint16_t sid, iova_t iova, phys_addr_t pa, size_t size)
>   
>   	if (!ce->present) {
>   		slptptr = alloc_page();
> -		memset(slptptr, 0, PAGE_SIZE);
>   		memset(ce, 0, sizeof(*ce));
>   		/* To make it simple, domain ID is the same as SID */
>   		ce->domain_id = sid;
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 250537b..5a07afe 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -403,7 +403,6 @@ int main(void)
>   
>   	pt = alloc_page();
>   	cr3 = (void*)read_cr3();
> -	memset(pt, 0, 4096);
>   	/* use shadowed stack during interrupt delivery */
>   	for (i = 0; i < 4096/sizeof(ulong); i++) {
>   		if (!cr3[i]) {
> diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
> index 5d541c9..8eade41 100644
> --- a/x86/hyperv_connections.c
> +++ b/x86/hyperv_connections.c
> @@ -47,7 +47,6 @@ static void setup_hypercall(void)
>   	hypercall_page = alloc_page();
>   	if (!hypercall_page)
>   		report_abort("failed to allocate hypercall page");
> -	memset(hypercall_page, 0, PAGE_SIZE);
>   
>   	wrmsr(HV_X64_MSR_GUEST_OS_ID, guestid);
>   
> @@ -105,9 +104,6 @@ static void setup_cpu(void *ctx)
>   	hv->post_msg = alloc_page();
>   	if (!hv->msg_page || !hv->evt_page || !hv->post_msg)
>   		report_abort("failed to allocate synic pages for vcpu");
> -	memset(hv->msg_page, 0, sizeof(*hv->msg_page));
> -	memset(hv->evt_page, 0, sizeof(*hv->evt_page));
> -	memset(hv->post_msg, 0, sizeof(*hv->post_msg));
>   	hv->msg_conn = MSG_CONN_BASE + vcpu;
>   	hv->evt_conn = EVT_CONN_BASE + vcpu;
>   
> diff --git a/x86/vmx.c b/x86/vmx.c
> index be47800..962ec0f 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -353,7 +353,6 @@ static void test_vmwrite_vmread(void)
>   	struct vmcs *vmcs = alloc_page();
>   	u32 vmcs_enum_max, max_index = 0;
>   
> -	memset(vmcs, 0, PAGE_SIZE);
>   	vmcs->hdr.revision_id = basic.revision;
>   	assert(!vmcs_clear(vmcs));
>   	assert(!make_vmcs_current(vmcs));
> @@ -373,7 +372,6 @@ static void test_vmcs_high(void)
>   {
>   	struct vmcs *vmcs = alloc_page();
>   
> -	memset(vmcs, 0, PAGE_SIZE);
>   	vmcs->hdr.revision_id = basic.revision;
>   	assert(!vmcs_clear(vmcs));
>   	assert(!make_vmcs_current(vmcs));
> @@ -400,7 +398,6 @@ static void test_vmcs_lifecycle(void)
>   
>   	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
>   		vmcs[i] = alloc_page();
> -		memset(vmcs[i], 0, PAGE_SIZE);
>   		vmcs[i]->hdr.revision_id = basic.revision;
>   	}
>   
> @@ -647,7 +644,6 @@ static void test_vmclear_flushing(void)
>   
>   	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
>   		vmcs[i] = alloc_page();
> -		memset(vmcs[i], 0, PAGE_SIZE);
>   	}
>   
>   	vmcs[0]->hdr.revision_id = basic.revision;
> @@ -745,7 +741,6 @@ static void split_large_ept_entry(unsigned long *ptep, int level)
>   
>   	new_pt = alloc_page();
>   	assert(new_pt);
> -	memset(new_pt, 0, PAGE_SIZE);
>   
>   	prototype = pte & ~EPT_ADDR_MASK;
>   	if (level == 2)
> @@ -1220,7 +1215,6 @@ static void init_vmcs_guest(void)
>   static int init_vmcs(struct vmcs **vmcs)
>   {
>   	*vmcs = alloc_page();
> -	memset(*vmcs, 0, PAGE_SIZE);
>   	(*vmcs)->hdr.revision_id = basic.revision;
>   	/* vmclear first to init vmcs */
>   	if (vmcs_clear(*vmcs)) {
> @@ -1259,7 +1253,6 @@ static void init_vmx(void)
>   	ulong fix_cr4_set, fix_cr4_clr;
>   
>   	vmxon_region = alloc_page();
> -	memset(vmxon_region, 0, PAGE_SIZE);
>   
>   	vmcs_root = alloc_page();
>   
> @@ -1291,9 +1284,7 @@ static void init_vmx(void)
>   	*vmxon_region = basic.revision;
>   
>   	guest_stack = alloc_page();
> -	memset(guest_stack, 0, PAGE_SIZE);
>   	guest_syscall_stack = alloc_page();
> -	memset(guest_syscall_stack, 0, PAGE_SIZE);
>   }
>   
>   static void do_vmxon_off(void *data)
> @@ -1420,7 +1411,6 @@ static void test_vmptrst(void)
>   	struct vmcs *vmcs1, *vmcs2;
>   
>   	vmcs1 = alloc_page();
> -	memset(vmcs1, 0, PAGE_SIZE);
>   	init_vmcs(&vmcs1);
>   	ret = vmcs_save(&vmcs2);
>   	report("test vmptrst", (!ret) && (vmcs1 == vmcs2));
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2d6b12d..c52ebc6 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -253,7 +253,6 @@ static void msr_bmp_init(void)
>   	u32 ctrl_cpu0;
>   
>   	msr_bitmap = alloc_page();
> -	memset(msr_bitmap, 0x0, PAGE_SIZE);
>   	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
>   	ctrl_cpu0 |= CPU_MSR_BITMAP;
>   	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
> @@ -627,8 +626,6 @@ static int iobmp_init(struct vmcs *vmcs)
>   
>   	io_bitmap_a = alloc_page();
>   	io_bitmap_b = alloc_page();
> -	memset(io_bitmap_a, 0x0, PAGE_SIZE);
> -	memset(io_bitmap_b, 0x0, PAGE_SIZE);
>   	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
>   	ctrl_cpu0 |= CPU_IO_BITMAP;
>   	ctrl_cpu0 &= (~CPU_IO);
> @@ -1062,8 +1059,6 @@ static int setup_ept(bool enable_ad)
>   	if (__setup_ept(virt_to_phys(pml4), enable_ad))
>   		return 1;
>   
> -	memset(pml4, 0, PAGE_SIZE);
> -
>   	end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
>   	if (end_of_memory < (1ul << 32))
>   		end_of_memory = (1ul << 32);
> @@ -1135,8 +1130,6 @@ static int ept_init_common(bool have_ad)
>   		return VMX_TEST_EXIT;
>   	data_page1 = alloc_page();
>   	data_page2 = alloc_page();
> -	memset(data_page1, 0x0, PAGE_SIZE);
> -	memset(data_page2, 0x0, PAGE_SIZE);
>   	*((u32 *)data_page1) = MAGIC_VAL_1;
>   	*((u32 *)data_page2) = MAGIC_VAL_2;
>   	install_ept(pml4, (unsigned long)data_page1, (unsigned long)data_page2,
> @@ -1483,7 +1476,6 @@ static int pml_init(struct vmcs *vmcs)
>   	}
>   
>   	pml_log = alloc_page();
> -	memset(pml_log, 0x0, PAGE_SIZE);
>   	vmcs_write(PMLADDR, (u64)pml_log);
>   	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
>   
> @@ -1908,9 +1900,6 @@ static int msr_switch_init(struct vmcs *vmcs)
>   	exit_msr_store = alloc_page();
>   	exit_msr_load = alloc_page();
>   	entry_msr_load = alloc_page();
> -	memset(exit_msr_store, 0, PAGE_SIZE);
> -	memset(exit_msr_load, 0, PAGE_SIZE);
> -	memset(entry_msr_load, 0, PAGE_SIZE);
>   	entry_msr_load[0].index = MSR_KERNEL_GS_BASE;
>   	entry_msr_load[0].value = MSR_MAGIC;
>   

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
