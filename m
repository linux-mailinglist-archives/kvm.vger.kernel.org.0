Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9244C9363
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiCASjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiCASi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:38:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B8A36E07;
        Tue,  1 Mar 2022 10:38:16 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221Hg2I0022688;
        Tue, 1 Mar 2022 18:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vv//N4II9hD10oM0jtbVJL3G0F/p5Xd+VTz9zzm9cJM=;
 b=SRQzJvP6NLa7N1X0g5Rwgr1dOzkZ60HWi89YH1YspyqJqbrSoNDscn2jw2DtA7RzhUA7
 NTrxXhaFXuYgbdxwsVxjEHeRvU/AUCQWNUIt0dGV66enivqQsCQnHH/GdGjfe0poC+Ji
 d0lENnHYBuS4/CUuASydPrIVaZgjq/8VniFvxFs0A6cstCEoueuxKHp/BMghb7af8WUN
 kATuZCF9ykqsQGr/HiCYdXbKE+VdQV0pcihiqQip5XeWHD2nFJ9M8c5ABxmaq8ijX6xO
 x/T2c6JziUeQkfn+kZrggeJkk5ZbKqJ/4UAiiTliQqsHkALAszcdPEfRCCiMx2jcChs6 GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehr421ab5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 221IRGjb018860;
        Tue, 1 Mar 2022 18:38:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehr421aae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 221IRkiA004362;
        Tue, 1 Mar 2022 18:38:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu9cgfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 221Ic4Ao53805564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Mar 2022 18:38:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B05B64C040;
        Tue,  1 Mar 2022 18:38:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F2404C044;
        Tue,  1 Mar 2022 18:38:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Mar 2022 18:38:04 +0000 (GMT)
Date:   Tue, 1 Mar 2022 18:32:36 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 3/9] KVM: s390: pv: Add query interface
Message-ID: <20220301183236.742e749b@p-imbrenda>
In-Reply-To: <b2fd362a-eefa-8fa7-1016-55bedd3fa6ee@redhat.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
        <20220223092007.3163-4-frankja@linux.ibm.com>
        <b2fd362a-eefa-8fa7-1016-55bedd3fa6ee@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C7NAi_3PHdS0D7PnWkce9ylhNr3ZzBfM
X-Proofpoint-GUID: 7JjnqGIsTkbVlPMLhrAr-YJHdkCxrtDK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 12:30:36 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 23/02/2022 10.20, Janosch Frank wrote:
> > Some of the query information is already available via sysfs but
> > having a IOCTL makes the information easier to retrieve.

why not exporting this via sysfs too?

something like a sysfs file called "query_ultravisor_information_raw"

that way you don't even have a problem with sizes

> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >   arch/s390/kvm/kvm-s390.c | 47 ++++++++++++++++++++++++++++++++++++++++
> >   include/uapi/linux/kvm.h | 23 ++++++++++++++++++++
> >   2 files changed, 70 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index faa85397b6fb..837f898ad2ff 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2217,6 +2217,34 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	return r;
> >   }
> >   
> > +static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
> > +{
> > +	u32 len;
> > +
> > +	switch (info->header.id) {
> > +	case KVM_PV_INFO_VM: {
> > +		len =  sizeof(info->header) + sizeof(info->vm);
> > +
> > +		if (info->header.len < len)
> > +			return -EINVAL;
> > +
> > +		memcpy(info->vm.inst_calls_list,
> > +		       uv_info.inst_calls_list,
> > +		       sizeof(uv_info.inst_calls_list));
> > +
> > +		/* It's max cpuidm not max cpus so it's off by one */
> > +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
> > +		info->vm.max_guests = uv_info.max_num_sec_conf;
> > +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
> > +		info->vm.feature_indication = uv_info.uv_feature_indications;
> > +
> > +		return 0;
> > +	}
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> >   static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >   {
> >   	int r = 0;
> > @@ -2353,6 +2381,25 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >   			     cmd->rc, cmd->rrc);
> >   		break;
> >   	}
> > +	case KVM_PV_INFO: {
> > +		struct kvm_s390_pv_info info = {};
> > +
> > +		if (copy_from_user(&info, argp, sizeof(info.header)))
> > +			return -EFAULT;
> > +
> > +		if (info.header.len < sizeof(info.header))
> > +			return -EINVAL;
> > +
> > +		r = kvm_s390_handle_pv_info(&info);
> > +		if (r)
> > +			return r;
> > +
> > +		r = copy_to_user(argp, &info, sizeof(info));  
> 
> sizeof(info) is currently OK ... but this might break if somebody later 
> extends the kvm_s390_pv_info struct, I guess? ==> Maybe also better use 
> sizeof(info->header) + sizeof(info->vm) here, too? Or let 
> kvm_s390_handle_pv_info() return the amount of bytes that should be copied here?
> 
>   Thomas
> 
> 
> > +		if (r)
> > +			return -EFAULT;
> > +		return 0;
> > +	}
> >   	default:
> >   		r = -ENOTTY;
> >   	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index dbc550bbd9fa..96fceb204a92 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1642,6 +1642,28 @@ struct kvm_s390_pv_unp {
> >   	__u64 tweak;
> >   };
> >   
> > +enum pv_cmd_info_id {
> > +	KVM_PV_INFO_VM,
> > +};
> > +
> > +struct kvm_s390_pv_info_vm {
> > +	__u64 inst_calls_list[4];
> > +	__u64 max_cpus;
> > +	__u64 max_guests;
> > +	__u64 max_guest_addr;
> > +	__u64 feature_indication;
> > +};
> > +
> > +struct kvm_s390_pv_info_header {
> > +	__u32 id;
> > +	__u32 len;
> > +};
> > +
> > +struct kvm_s390_pv_info {
> > +	struct kvm_s390_pv_info_header header;
> > +	struct kvm_s390_pv_info_vm vm;
> > +};
> > +
> >   enum pv_cmd_id {
> >   	KVM_PV_ENABLE,
> >   	KVM_PV_DISABLE,
> > @@ -1650,6 +1672,7 @@ enum pv_cmd_id {
> >   	KVM_PV_VERIFY,
> >   	KVM_PV_PREP_RESET,
> >   	KVM_PV_UNSHARE_ALL,
> > +	KVM_PV_INFO,
> >   };
> >   
> >   struct kvm_pv_cmd {  
> 

