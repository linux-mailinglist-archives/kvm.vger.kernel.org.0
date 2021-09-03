Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D96A400751
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 23:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhICVNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 17:13:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232927AbhICVNq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 17:13:46 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183L3Nwv067760;
        Fri, 3 Sep 2021 17:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/GsTZn5HfNXX+Zfb8s0LMtKlmRi7VmMCu35U9x/V1Ao=;
 b=jDU4nbuGdocRGOGVqPgdYbPh9tAVtEvWzKAPSdWWD/P0DujcgGBgmMMRXyjs/ZfLO7s7
 VqW2tiqW6vSs3mv+xLNDqOHZ4KPoK8pW4Z3J0ZB+9HrFdbEFl7fp/ISH9chJ1nALRFxu
 Vleug0n1xqGReppfofysYwX9DKwBxlg0tZ1PHciAfkm+MOS2/OA6FtCQMaVMrzmslCGb
 h7Alxo2yMGbIb9qiiNSjtVhHakoExX5VTTK0PyNligfl8NV9i+6B9GJuGCtC7OmT4GkI
 /MftdSHRgC8eoCEKYWhcRfhzO0WVcDLGAN8gRJAu6A0aKy1C7wXStBQTpJFHOYRW1lnD 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3autsv8rw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 17:12:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183L3PMW067922;
        Fri, 3 Sep 2021 17:12:35 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3autsv8rvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 17:12:35 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183L2ppT012785;
        Fri, 3 Sep 2021 21:12:34 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3au6pjxn0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 21:12:34 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183LCWho38011348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 21:12:33 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5900C605F;
        Fri,  3 Sep 2021 21:12:32 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 530E2C60F5;
        Fri,  3 Sep 2021 21:12:22 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  3 Sep 2021 21:12:21 +0000 (GMT)
Subject: Re: [RFC PATCH v2 03/12] i386/sev: introduce 'sev-snp-guest' object
To:     Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-4-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <1efdd7a3-b712-06a1-90e1-7ca8134f5506@linux.ibm.com>
Date:   Sat, 4 Sep 2021 00:12:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826222627.3556-4-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aXkRfiL1Z-JgNlZmnty11Z1RpL6gIyoO
X-Proofpoint-GUID: I2DoBW9oo6EVNhxfhZxTSOcdSlRm8WFi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_07:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/08/2021 1:26, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> SEV-SNP support relies on a different set of properties/state than the
> existing 'sev-guest' object. This patch introduces the 'sev-snp-guest'
> object, which can be used to configure an SEV-SNP guest. For example,
> a default-configured SEV-SNP guest with no additional information
> passed in for use with attestation:
> 
>   -object sev-snp-guest,id=sev0
> 
> or a fully-specified SEV-SNP guest where all spec-defined binary
> blobs are passed in as base64-encoded strings:
> 
>   -object sev-snp-guest,id=sev0, \
>     policy=0x30000, \
>     init-flags=0, \
>     id-block=YWFhYWFhYWFhYWFhYWFhCg==, \
>     id-auth=CxHK/OKLkXGn/KpAC7Wl1FSiisWDbGTEKz..., \
>     auth-key-enabled=on, \
>     host-data=LNkCWBRC5CcdGXirbNUV1OrsR28s..., \
>     guest-visible-workarounds=AA==, \
> 
> See the QAPI schema updates included in this patch for more usage
> details.
> 
> In some cases these blobs may be up to 4096 characters, but this is
> generally well below the default limit for linux hosts where
> command-line sizes are defined by the sysconf-configurable ARG_MAX
> value, which defaults to 2097152 characters for Ubuntu hosts, for
> example.
> 
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  docs/amd-memory-encryption.txt |  77 ++++++++++-
>  qapi/qom.json                  |  60 ++++++++
>  target/i386/sev.c              | 245 ++++++++++++++++++++++++++++++++-
>  3 files changed, 379 insertions(+), 3 deletions(-)
> 
> diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
> index ffca382b5f..0d82e67fa1 100644
> --- a/docs/amd-memory-encryption.txt
> +++ b/docs/amd-memory-encryption.txt
> @@ -22,8 +22,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
>  are about to occur. This allows the guest to selectively share information with
>  the hypervisor to satisfy the requested function.
>  
> -Launching
> ----------
> +Launching (SEV and SEV-ES)
> +--------------------------
>  Boot images (such as bios) must be encrypted before a guest can be booted. The
>  MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images: LAUNCH_START,
>  LAUNCH_UPDATE_DATA, LAUNCH_MEASURE and LAUNCH_FINISH. These four commands
> @@ -113,6 +113,79 @@ a SEV-ES guest:
>   - Requires in-kernel irqchip - the burden is placed on the hypervisor to
>     manage booting APs.
>  
> +Launching (SEV-SNP)
> +-------------------
> +Boot images (such as bios) must be encrypted before a guest can be booted. The
> +MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images:
> +KVM_SNP_INIT, SNP_LAUNCH_START, SNP_LAUNCH_UPDATE, and SNP_LAUNCH_FINISH. These
> +four commands together generate a fresh memory encryption key for the VM,
> +encrypt the boot images for a successful launch.
> +
> +KVM_SNP_INIT is called first to initialize the SEV-SNP firmware and SNP
> +features in the KVM. The feature flags value can be provided through the
> +'init-flags' property of the 'sev-snp-guest' object.
> +
> ++------------+-------+----------+---------------------------------+
> +| key        | type  | default  | meaning                         |
> ++------------+-------+----------+---------------------------------+
> +| init_flags | hex   | 0        | SNP feature flags               |
> ++-----------------------------------------------------------------+
> +
> +Note: currently the init_flags must be zero.
> +
> +SNP_LAUNCH_START is called first to create a cryptographic launch context
> +within the firmware. To create this context, guest owner must provide a guest
> +policy and other parameters as described in the SEV-SNP firmware
> +specification. The launch parameters should be specified as described in the
> +QAPI schema for the 'sev-snp-guest' object.
> +
> +The SNP_LAUNCH_START uses the following parameters (see the SEV-SNP
> +specification for more details):
> +
> ++--------+-------+----------+----------------------------------------------+
> +| key    | type  | default  | meaning                                      |
> ++--------+-------+----------+----------------------------------------------+
> +| policy | hex   | 0x30000  | a 64-bit guest policy                        |
> +| imi_en | bool  | 0        | 1 when IMI is enabled                        |
> +| ma_end | bool  | 0        | 1 when migration agent is used               |
> +| gosvw  | string| 0        | 16-byte base64 encoded string for the guest  |
> +|        |       |          | OS visible workaround.                       |
> ++--------+-------+----------+----------------------------------------------+
> +
> +SNP_LAUNCH_UPDATE encrypts the memory region using the cryptographic context
> +created via the SNP_LAUNCH_START command. If required, this command can be called
> +multiple times to encrypt different memory regions. The command also calculates
> +the measurement of the memory contents as it encrypts.
> +
> +SNP_LAUNCH_FINISH finalizes the guest launch flow. Optionally, while finalizing
> +the launch the firmware can perform checks on the launch digest computing
> +through the SNP_LAUNCH_UPDATE. To perform the check the user must supply
> +the id block, authentication blob and host data that should be included in the
> +attestation report. See the SEV-SNP spec for further details.
> +
> +The SNP_LAUNCH_FINISH uses the following parameters, which can be configured
> +by the corresponding parameters documented in the QAPI schema for the
> +'sev-snp-guest' object.
> +
> ++------------+-------+----------+----------------------------------------------+
> +| key        | type  | default  | meaning                                      |
> ++------------+-------+----------+----------------------------------------------+
> +| id_block   | string| none     | base64 encoded ID block                      |
> ++------------+-------+----------+----------------------------------------------+
> +| id_auth    | string| none     | base64 encoded authentication information    |
> ++------------+-------+----------+----------------------------------------------+
> +| auth_key_en| bool  | 0        | auth block contains author key               |
> ++------------+-------+----------+----------------------------------------------+
> +| host_data  | string| none     | host provided data                           |
> ++------------+-------+----------+----------------------------------------------+
> +
> +To launch a SEV-SNP guest (additional parameters are documented in the QAPI
> +schema for the 'sev-snp-guest' object):
> +
> +# ${QEMU} \
> +    -machine ...,confidential-guest-support=sev0 \
> +    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1
> +
>  Debugging
>  -----------
>  Since the memory contents of a SEV guest are encrypted, hypervisor access to
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 211e083727..ea39585026 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -775,6 +775,64 @@
>              '*policy': 'uint32',
>              '*handle': 'uint32' } }
>  
> +##
> +# @SevSnpGuestProperties:
> +#
> +# Properties for sev-snp-guest objects. Many of these are direct arguments
> +# for the SEV-SNP KVM interfaces documented in the linux kernel source
> +# documentation under 'amd-memory-encryption.rst'. Additional documentation
> +# is also available in the QEMU source tree under
> +# 'amd-memory-encryption.rst'.
> +#
> +# In addition to those files, please see the SEV-SNP Firmware Specification
> +# (Rev 0.9) documentation for the SNP_INIT and
> +# SNP_LAUNCH_{START,UPDATE,FINISH} firmware interfaces, which the KVM
> +# interfaces are written against.
> +#
> +# @init-flags: as documented for the 'flags' parameter of the
> +#              KVM_SNP_INIT KVM command (default: 0)
> +#
> +# @policy: as documented for the 'policy' parameter of the
> +#          KVM_SNP_LAUNCH_START KVM command (default: 0x30000)
> +#
> +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> +#                             hypervisor-defined workarounds, as documented
> +#                             for the 'gosvm' parameter of the

typo: s/gosvm/gosvw/


> +#                             KVM_SNP_LAUNCH_START KVM command.
> +#                             (default: all-zero)
> +#
> +# @id-block: 8-byte, base64-encoded blob to provide the ID Block
> +#            structure documented in SEV-SNP spec, as documented for the
> +#            'id_block_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
> +#            command (default: all-zero)

The documentation says the ID Block is 96 bytes long (Table 65 in
section 8.15 of the SNP FW ABI document).


> +#
> +# @id-auth: 4096-byte, base64-encoded blob to provide the ID Authentication
> +#           Information Structure documented in SEV-SNP spec, as documented
> +#           for the 'id_auth_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
> +#           command (default: all-zero)
> +#
> +# @auth-key-enabled: true if 'id-auth' blob contains the Author Key
> +#                    documented in the SEV-SNP spec, as documented for the
> +#                    'auth_key_en' parameter of the KVM_SNP_LAUNCH_FINISH
> +#                    command (default: false)
> +#
> +# @host-data: 32-byte, base64-encoded user-defined blob to provide to the
> +#             guest, as documented for the 'host_data' parameter of the
> +#             KVM_SNP_LAUNCH_FINISH command (default: all-zero)
> +#
> +# Since: 6.2
> +##
> +{ 'struct': 'SevSnpGuestProperties',
> +  'base': 'SevCommonProperties',
> +  'data': {
> +            '*init-flags': 'uint64',
> +            '*policy': 'uint64',
> +            '*guest-visible-workarounds': 'str',
> +            '*id-block': 'str',
> +            '*id-auth': 'str',
> +            '*auth-key-enabled': 'bool',
> +            '*host-data': 'str' } }
> +
>  ##
>  # @ObjectType:
>  #
> @@ -816,6 +874,7 @@
>      'secret',
>      'secret_keyring',
>      'sev-guest',
> +    'sev-snp-guest',
>      's390-pv-guest',
>      'throttle-group',
>      'tls-creds-anon',
> @@ -873,6 +932,7 @@
>        'secret':                     'SecretProperties',
>        'secret_keyring':             'SecretKeyringProperties',
>        'sev-guest':                  'SevGuestProperties',
> +      'sev-snp-guest':              'SevSnpGuestProperties',
>        'throttle-group':             'ThrottleGroupProperties',
>        'tls-creds-anon':             'TlsCredsAnonProperties',
>        'tls-creds-psk':              'TlsCredsPskProperties',
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 6acebfbd53..ba08b7d3ab 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -38,7 +38,8 @@
>  OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
>  #define TYPE_SEV_GUEST "sev-guest"
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> -
> +#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
> +OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
>  
>  /**
>   * SevGuestState:
> @@ -82,8 +83,23 @@ struct SevGuestState {
>      char *session_file;
>  };
>  
> +struct SevSnpGuestState {
> +    SevCommonState sev_common;
> +
> +    /* configuration parameters */
> +    char *guest_visible_workarounds;
> +    char *id_block;
> +    char *id_auth;
> +    char *host_data;
> +
> +    struct kvm_snp_init kvm_init_conf;
> +    struct kvm_sev_snp_launch_start kvm_start_conf;
> +    struct kvm_sev_snp_launch_finish kvm_finish_conf;
> +};
> +
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> +#define DEFAULT_SEV_SNP_POLICY  0x30000
>  
>  #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
>  typedef struct __attribute__((__packed__)) SevInfoBlock {
> @@ -364,6 +380,232 @@ static const TypeInfo sev_guest_info = {
>      .class_init = sev_guest_class_init,
>  };
>  
> +static void
> +sev_snp_guest_get_init_flags(Object *obj, Visitor *v, const char *name,
> +                             void *opaque, Error **errp)
> +{
> +    visit_type_uint64(v, name,
> +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_init_conf.flags,
> +                      errp);
> +}
> +
> +static void
> +sev_snp_guest_set_init_flags(Object *obj, Visitor *v, const char *name,
> +                             void *opaque, Error **errp)
> +{
> +    visit_type_uint64(v, name,
> +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_init_conf.flags,
> +                      errp);
> +}
> +
> +static void
> +sev_snp_guest_get_policy(Object *obj, Visitor *v, const char *name,
> +                         void *opaque, Error **errp)
> +{
> +    visit_type_uint64(v, name,
> +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
> +                      errp);
> +}
> +
> +static void
> +sev_snp_guest_set_policy(Object *obj, Visitor *v, const char *name,
> +                         void *opaque, Error **errp)
> +{
> +    visit_type_uint64(v, name,
> +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
> +                      errp);
> +}
> +
> +static char *
> +sev_snp_guest_get_guest_visible_workarounds(Object *obj, Error **errp)
> +{
> +    return g_strdup(SEV_SNP_GUEST(obj)->guest_visible_workarounds);
> +}
> +
> +static void
> +sev_snp_guest_set_guest_visible_workarounds(Object *obj, const char *value,
> +                                            Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
> +    g_autofree guchar *blob;
> +    gsize len;
> +
> +    if (sev_snp_guest->guest_visible_workarounds) {
> +        g_free(sev_snp_guest->guest_visible_workarounds);
> +    }
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
> +
> +    blob = g_base64_decode(sev_snp_guest->guest_visible_workarounds, &len);

I see there's a qbase64_decode which performs some checks and then calls
g_base64_decode.  It might detect illegal chars in the value?

Also I think you should verify this decode succeeds by checking that
blob is not NULL.

(similar comments for all base64_decode calls in this file.)


> +    if (len > sizeof(start->gosvw)) {
> +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
> +                   len, sizeof(start->gosvw));
> +        return;
> +    }
> +
> +    memcpy(start->gosvw, blob, len);
> +}
> +
> +static char *
> +sev_snp_guest_get_id_block(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return g_strdup(sev_snp_guest->id_block);
> +}
> +
> +static void
> +sev_snp_guest_set_id_block(Object *obj, const char *value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> +    gsize len;
> +
> +    if (sev_snp_guest->id_block) {
> +        g_free(sev_snp_guest->id_block);
> +        g_free((guchar *)finish->id_block_uaddr);
> +    }
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->id_block = g_strdup(value);
> +
> +    finish->id_block_uaddr = (uint64_t)g_base64_decode(sev_snp_guest->id_block, &len);
> +    if (len > KVM_SEV_SNP_ID_BLOCK_SIZE) {
> +        error_setg(errp, "parameter length of %lu exceeds max of %u",
> +                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
> +        return;
> +    }
> +    finish->id_block_en = 1;

There's no way to set the id_block to a "don't want an ID block", except
for not giving this option to the sev-snp-guest object.  I'm not sure if
this is a problem (for example, if you dump one VM's config and try to
load it elsewhere).

Maybe if strlen(value)==0 you should set finish->id_block_en = 0.



> +}
> +
> +static char *
> +sev_snp_guest_get_id_auth(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return g_strdup(sev_snp_guest->id_auth);
> +}
> +
> +static void
> +sev_snp_guest_set_id_auth(Object *obj, const char *value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> +    gsize len;
> +
> +    if (sev_snp_guest->id_auth) {
> +        g_free(sev_snp_guest->id_auth);
> +        g_free((guchar *)finish->id_auth_uaddr);
> +    }
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->id_auth = g_strdup(value);
> +
> +    finish->id_auth_uaddr = (uint64_t)g_base64_decode(sev_snp_guest->id_auth, &len);
> +    if (len > KVM_SEV_SNP_ID_AUTH_SIZE) {
> +        error_setg(errp, "parameter length of %lu exceeds max of %u",
> +                   len, KVM_SEV_SNP_ID_AUTH_SIZE);
> +        return;
> +    }
> +}
> +
> +static bool
> +sev_snp_guest_get_auth_key_en(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return !!sev_snp_guest->kvm_finish_conf.auth_key_en;
> +}
> +
> +static void
> +sev_snp_guest_set_auth_key_en(Object *obj, bool value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    sev_snp_guest->kvm_finish_conf.auth_key_en = value;
> +}
> +
> +static char *
> +sev_snp_guest_get_host_data(Object *obj, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    return g_strdup(sev_snp_guest->host_data);
> +}
> +
> +static void
> +sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> +    g_autofree guchar *blob;
> +    gsize len;
> +
> +    if (sev_snp_guest->host_data) {
> +        g_free(sev_snp_guest->host_data);
> +    }
> +
> +    /* store the base64 str so we don't need to re-encode in getter */
> +    sev_snp_guest->host_data = g_strdup(value);
> +
> +    blob = g_base64_decode(sev_snp_guest->host_data, &len);
> +    if (len > sizeof(finish->host_data)) {
> +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
> +                   len, sizeof(finish->host_data));
> +        return;
> +    }
> +
> +    memcpy(finish->host_data, blob, len);
> +}
> +
> +static void
> +sev_snp_guest_class_init(ObjectClass *oc, void *data)
> +{
> +    object_class_property_add(oc, "init-flags", "uint64",
> +                              sev_snp_guest_get_init_flags,
> +                              sev_snp_guest_set_init_flags, NULL, NULL);
> +    object_class_property_set_description(oc, "init-flags",
> +        "guest initialization flags");
> +    object_class_property_add(oc, "policy", "uint64",
> +                              sev_snp_guest_get_policy,
> +                              sev_snp_guest_set_policy, NULL, NULL);
> +    object_class_property_add_str(oc, "guest-visible-workarounds",
> +                                  sev_snp_guest_get_guest_visible_workarounds,
> +                                  sev_snp_guest_set_guest_visible_workarounds);
> +    object_class_property_add_str(oc, "id-block",
> +                                  sev_snp_guest_get_id_block,
> +                                  sev_snp_guest_set_id_block);
> +    object_class_property_add_str(oc, "id-auth",
> +                                  sev_snp_guest_get_id_auth,
> +                                  sev_snp_guest_set_id_auth);
> +    object_class_property_add_bool(oc, "auth-key-enabled",
> +                                   sev_snp_guest_get_auth_key_en,
> +                                   sev_snp_guest_set_auth_key_en);
> +    object_class_property_add_str(oc, "host-data",
> +                                  sev_snp_guest_get_host_data,
> +                                  sev_snp_guest_set_host_data);
> +}
> +
> +static void
> +sev_snp_guest_instance_init(Object *obj)
> +{
> +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> +
> +    /* default init/start/finish params for kvm */
> +    sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
> +}
> +
> +/* guest info specific to sev-snp */
> +static const TypeInfo sev_snp_guest_info = {
> +    .parent = TYPE_SEV_COMMON,
> +    .name = TYPE_SEV_SNP_GUEST,
> +    .instance_size = sizeof(SevSnpGuestState),
> +    .class_init = sev_snp_guest_class_init,
> +    .instance_init = sev_snp_guest_instance_init,
> +};
> +
>  bool
>  sev_enabled(void)
>  {
> @@ -1136,6 +1378,7 @@ sev_register_types(void)
>  {
>      type_register_static(&sev_common_info);
>      type_register_static(&sev_guest_info);
> +    type_register_static(&sev_snp_guest_info);
>  }
>  
>  type_init(sev_register_types);
> 
