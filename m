Return-Path: <kvm+bounces-42550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9392A79CF8
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 09:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A5EF172BAC
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 07:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF3B2405F8;
	Thu,  3 Apr 2025 07:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UGYojsre"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B4823F41E
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743665335; cv=none; b=Sxlypn+gBXmbFM6HA/9lVBrXwD+gvCPxENqPoU9nV5NBblYFxjAn4hnXy+KsuH4eLWmYHp8FJCnpXJMStYFkjzZY2X2r8AdHa/yYVvSE93ZiaVJPwx/N1ERjvIMrimtcYrDsINHXtOzw4CKnjVhv29T/NsnPbLMgOZIGNOdrNR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743665335; c=relaxed/simple;
	bh=GrCfaQFUC54J0kOTNsitpfCgrWLlREmRQDOWxJ1CPHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rdwm1cELG+TB9cQJ7vB9FogjkWab4m16j1l6rtRwJ6iWHd0YrXbt8sW2t6HMoWhNONa13n60WKHYisvNVh9waax3IYG2eCVKAFTHaymg8ceou7LTky7HV6mxlaeLMTZi17T10xb5Nc1VqvTVB+22wpWzEvqKoiDYQ3uvi+zBrN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UGYojsre; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743665334; x=1775201334;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GrCfaQFUC54J0kOTNsitpfCgrWLlREmRQDOWxJ1CPHo=;
  b=UGYojsre2axilA57j1k6IAouklq08ijK8tunKvN2IsFWR5GZ3SyZVL0Z
   Jtdp9RXBn1OIpG3K6wDwWl2t6xrBwdAmhSyTTnsKl1ufh3CvyflDJ0t6u
   C2r04lkWMJpDmUmmLWCeBMM3rhhy8QOz/SJPYzjioo8RVk+uFvZ7wy9XW
   2BGcYTrmGN/27RqnG/ivFPICOc4jEcollhNjwrDThsUDCmzfFO7kL3UG3
   Z6EqGIj0s/UsnCoOzrblbWTUk1obmHrGRUBO2OCSPy/8v0cWw1s0ySxF3
   98lKsObD/iPKt91OhIDcdaHik46JH0O4camsHx4F4PSbJ1WWZ1coynRI4
   g==;
X-CSE-ConnectionGUID: MaZHlp2uTm6Ro5HGYsp8Ug==
X-CSE-MsgGUID: vYx+0ofbQbaEvRRLXkk3iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="44968589"
X-IronPort-AV: E=Sophos;i="6.15,184,1739865600"; 
   d="scan'208";a="44968589"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 00:28:53 -0700
X-CSE-ConnectionGUID: 5T8DoO9USCmOPs6tGU8Hfg==
X-CSE-MsgGUID: pk/bJ9amTOWMhdlfa9uW7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,184,1739865600"; 
   d="scan'208";a="157880579"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 00:28:46 -0700
Message-ID: <a3a8ed8d-9994-42c9-ba3b-ef59d6977ce6@intel.com>
Date: Thu, 3 Apr 2025 15:28:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com> <Zv7dtghi20DZ9ozz@redhat.com>
 <0e15f14b-cd63-4ec4-8232-a5c0a96ba31d@intel.com>
 <Z-1cm6cEwNGs9NEu@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z-1cm6cEwNGs9NEu@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/2/2025 11:49 PM, Daniel P. Berrangé wrote:
> On Wed, Apr 02, 2025 at 11:26:11PM +0800, Xiaoyao Li wrote:
>> Sorry for the late response.
>>
>> KVM part of TDX attestation support is submitting again. QEMU part will
>> follow and we need to settle dowm this topic before QEMU patches submission.
>>
>> On 10/4/2024 2:08 AM, Daniel P. Berrangé wrote:
>>> On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Add property "quote-generation-socket" to tdx-guest, which is a property
>>>> of type SocketAddress to specify Quote Generation Service(QGS).
>>>>
>>>> On request of GetQuote, it connects to the QGS socket, read request
>>>> data from shared guest memory, send the request data to the QGS,
>>>> and store the response into shared guest memory, at last notify
>>>> TD guest by interrupt.
>>>>
>>>> command line example:
>>>>     qemu-system-x86_64 \
>>>>       -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>>>       -machine confidential-guest-support=tdx0
>>>>
>>>> Note, above example uses vsock type socket because the QGS we used
>>>> implements the vsock socket. It can be other types, like UNIX socket,
>>>> which depends on the implementation of QGS.
>>>>
>>>> To avoid no response from QGS server, setup a timer for the transaction.
>>>> If timeout, make it an error and interrupt guest. Define the threshold of
>>>> time to 30s at present, maybe change to other value if not appropriate.
>>>>
>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>>
>>>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>>>> index 49f94d9d46f4..7dfda507cc8c 100644
>>>> --- a/target/i386/kvm/tdx.c
>>>> +++ b/target/i386/kvm/tdx.c
>>>
>>>> +static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
>>>> +{
>>>> +    struct tdx_generate_quote_task *task;
>>>> +    struct tdx_get_quote_header hdr;
>>>> +    hwaddr buf_gpa = vmcall->in_r12;
>>>> +    uint64_t buf_len = vmcall->in_r13;
>>>> +
>>>> +    QEMU_BUILD_BUG_ON(sizeof(struct tdx_get_quote_header) != TDX_GET_QUOTE_HDR_SIZE);
>>>> +
>>>> +    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
>>>> +
>>>> +    if (buf_len == 0) {
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    /* GPA must be shared. */
>>>> +    if (!(buf_gpa & tdx_shared_bit(cpu))) {
>>>> +        return 0;
>>>> +    }
>>>> +    buf_gpa &= ~tdx_shared_bit(cpu);
>>>> +
>>>> +    if (!QEMU_IS_ALIGNED(buf_gpa, 4096) || !QEMU_IS_ALIGNED(buf_len, 4096)) {
>>>> +        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    if (address_space_read(&address_space_memory, buf_gpa, MEMTXATTRS_UNSPECIFIED,
>>>> +                           &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
>>>> +        error_report("TDX: get-quote: failed to read GetQuote header.\n");
>>>> +        return -1;
>>>> +    }
>>>> +
>>>> +    if (le64_to_cpu(hdr.structure_version) != TDX_GET_QUOTE_STRUCTURE_VERSION) {
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * Paranoid: Guest should clear error_code and out_len to avoid information
>>>> +     * leak.  Enforce it.  The initial value of them doesn't matter for qemu to
>>>> +     * process the request.
>>>> +     */
>>>> +    if (le64_to_cpu(hdr.error_code) != TDX_VP_GET_QUOTE_SUCCESS ||
>>>> +        le32_to_cpu(hdr.out_len) != 0) {
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    /* Only safe-guard check to avoid too large buffer size. */
>>>> +    if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
>>>> +        le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
>>>> +    if (!tdx_guest->quote_generator) {
>>>> +        hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
>>>> +        if (address_space_write(&address_space_memory, buf_gpa,
>>>> +                                MEMTXATTRS_UNSPECIFIED,
>>>> +                                &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
>>>> +            error_report("TDX: failed to update GetQuote header.\n");
>>>> +            return -1;
>>>> +        }
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    qemu_mutex_lock(&tdx_guest->quote_generator->lock);
>>>> +    if (tdx_guest->quote_generator->num >= TDX_MAX_GET_QUOTE_REQUEST) {
>>>> +        qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
>>>> +        vmcall->status_code = TDG_VP_VMCALL_RETRY;
>>>> +        return 0;
>>>> +    }
>>>> +    tdx_guest->quote_generator->num++;
>>>> +    qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
>>>> +
>>>> +    /* Mark the buffer in-flight. */
>>>> +    hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_IN_FLIGHT);
>>>> +    if (address_space_write(&address_space_memory, buf_gpa,
>>>> +                            MEMTXATTRS_UNSPECIFIED,
>>>> +                            &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
>>>> +        error_report("TDX: failed to update GetQuote header.\n");
>>>> +        return -1;
>>>> +    }
>>>> +
>>>> +    task = g_malloc(sizeof(*task));
>>>> +    task->buf_gpa = buf_gpa;
>>>> +    task->payload_gpa = buf_gpa + TDX_GET_QUOTE_HDR_SIZE;
>>>> +    task->payload_len = buf_len - TDX_GET_QUOTE_HDR_SIZE;
>>>> +    task->hdr = hdr;
>>>> +    task->quote_gen = tdx_guest->quote_generator;
>>>> +    task->completion = tdx_get_quote_completion;
>>>> +
>>>> +    task->send_data_size = le32_to_cpu(hdr.in_len);
>>>> +    task->send_data = g_malloc(task->send_data_size);
>>>> +    task->send_data_sent = 0;
>>>> +
>>>> +    if (address_space_read(&address_space_memory, task->payload_gpa,
>>>> +                           MEMTXATTRS_UNSPECIFIED, task->send_data,
>>>> +                           task->send_data_size) != MEMTX_OK) {
>>>> +        g_free(task->send_data);
>>>> +        return -1;
>>>> +    }
>>>
>>> In this method we've received "struct tdx_get_quote_header" from
>>> the guest OS, and the 'hdr.in_len' field in that struct tells us
>>> the payload to read from guest memory. This payload is treated as
>>> opaque by QEMU and sent over the UNIX socket directly to QGS with
>>> no validation of the payload.
>>>
>>> The payload is supposed to be a raw TDX report, that QGS will turn
>>> into a quote.
>>>
>>> Nothing guarantees that the guest OS has actually given QEMU a
>>> payload that represents a TDX report.
>>>
>>> The only validation done in this patch is to check the 'hdr.in_len'
>>> was not ridiculously huge:
>>>
>>>        #define TDX_GET_QUOTE_MAX_BUF_LEN       (128 * 1024)
>>>
>>>        #define TDX_GET_QUOTE_HDR_SIZE          24
>>>
>>>        ...
>>>        /* Only safe-guard check to avoid too large buffer size. */
>>>        if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
>>>            le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
>>>            return 0;
>>>        }
>>>
>>> IOW, hdr.in_len can be any value between 0 and 131048, and
>>> the payload data read can contain arbitrary bytes.
>>>
>>>
>>> Over in the QGS code, QGS historically had a socket protocol
>>> taking various messages from the libtdxattest library which
>>> were defined in this:
>>>
>>>     https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs_msg_lib/inc/qgs_msg_lib.h
>>>
>>>     typedef enum _qgs_msg_type_t {
>>>       GET_QUOTE_REQ = 0,
>>>       GET_QUOTE_RESP = 1,
>>>       GET_COLLATERAL_REQ = 2,
>>>       GET_COLLATERAL_RESP = 3,
>>>       GET_PLATFORM_INFO_REQ = 4,
>>>       GET_PLATFORM_INFO_RESP = 5,
>>>       QGS_MSG_TYPE_MAX
>>>     } qgs_msg_type_t;
>>>
>>>     typedef struct _qgs_msg_header_t {
>>>       uint16_t major_version;
>>>       uint16_t minor_version;
>>>       uint32_t type;
>>>       uint32_t size;              // size of the whole message, include this header, in byte
>>>       uint32_t error_code;        // used in response only
>>>     } qgs_msg_header_t;
>>>
>>> such messages are processed by the 'get_resp' method in QGS:
>>>
>>>     https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs/qgs_ql_logic.cpp#L78
>>>
>>> The 1.21 release of DCAP introduced a new "raw" mode in QGS which
>>> just receives the raw 1024 byte packet from the client which is
>>> supposed to be a raw TDX report.  This is what this QEMU patch
>>> is relying on IIUC.
>>>
>>>
>>> The QGS daemon decides whether a client is speaking the formal
>>> protocol, or "raw" mode, by trying to interpret the incoming
>>> data as a 'qgs_msg_header_t' struct. If the header size looks
>>> wrong & it has exactly 1024 bytes, then QGS assumes it has got
>>> a raw TDX report:
>>>
>>>     https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs/qgs_server.cpp#L165
>>>
>>> This all works if the data QEMU gets from the guest is indeed a
>>> 1024 byte raw TDX report, but what happens if we face a malicious
>>> guest ?
>>>
>>> AFAICT, the guest OS is able to send a "qgs_msg_header_t" packet
>>> to QEMU, which QEMU blindly passes on to QGS. This allows the
>>> guest OS to invoke any of the three QGS commands - GET_QUOTE_REQ,
>>> GET_COLLATERAL_REQ, or GET_PLATFORM_INFO_REQ. Fortunately I think
>>> those three messages are all safe to invoke, but none the less,
>>> this should not be permitted, as it leaves a wide open door for
>>> possible future exploits.
>>>
>>> As mentioned before, I don't know why this raw mode was invented
>>> for QGS, when QEMU itself could just take the guest report and
>>> pack it into the 'GET_QUOTE_REQ' message format and send it to
>>> QGS. This prevents the guest OS from being able to exploit QEMU
>>> to invoke arbirtary QGS messages.
>>
>> I guess the raw mode was introduced due to the design was changed to let
>> guest kernel to forward to TD report to host QGS via TDVMCALL instead of
>> guest application communicates with host QGS via vsock, and Linux TD guest
>> driver doesn't integrate any QGS protocol but just forward the raw TD report
>> data to KVM.
>>
>>> IMHO, QEMU should be made to pack & unpack the TDX report from
>>> the guest into the GET_QUOTE_REQ / GET_QUOTE_RESP messages, and
>>> this "raw" mode should be removed to QGS as it is inherantly
>>> dangerous to have this magic protocol overloading.
>>
>> There is no enforcement that the input data of TDVMCALL.GetQuote is the raw
>> data of TD report. It is just the current Linux tdx-guest driver of tsm
>> implementation send the raw data. For other TDX OS, or third-party driver,
>> they might encapsulate the raw TD report data with QGS message header. For
>> such cases, if QEMU adds another layer of package, it leads to the wrong
>> result.
> 
> If I look at the GHCI spec
> 
>    https://cdrdv2-public.intel.com/726790/TDX%20Guest-Hypervisor%20Communication%20Interface_1.0_344426_006%20-%2020230311.pdf
> 
> In "3.3 TDG.VP.VMCALL<GetQuote>", it indicates the parameter is a
> "TDREPORT_STRUCT". IOW, it doesn't look valid to allow the guest to
> send arbitrary other data as QGS protocol messages.

In table 3-7, the description of R12 is

   Shared GPA as input - the memory contains a TDREPORT_STRUCT.
   The same buffer is used as output - the memory contains a TD Quote.

table 3-10, describes the detailed format of the shared GPA:

starting from offset 24 bytes, it is the "Data"

   On input, the data filled by TD with input length. The data should
   include TDREPORT_STRUCT. TD should zeroize the remaining buffer to
   avoid information leak if size of shared GPA (R13) > Input Length.

It uses the word "contains" and "include", but without "only". So it is 
not clear to me.

I will work with internal attestation folks to make it clearer that who 
(TD guest or host VMM) is responsible to encapsulate the raw 
TDERPORT_STRCUT with QGS MSG protocol, and update the spec accordingly.

>> If we are going to pack the input data of GETQUOTE in QEMU, it becomes a
>> hard requirement from QEMU that the input data of GETQUOTE must be raw data
>> of TD report.
> 
> AFAICT it must be a raw TDREPORT_STRUCT per the spec and thus QEMU must not
> allow anything different, as that exposes a significantly larger security
> attack surface on the QGS daemon.
> 
> With regards,
> Daniel


