Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB7E2759FA
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 16:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIWOaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 10:30:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgIWO35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 10:29:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NESmcV187370;
        Wed, 23 Sep 2020 14:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/kWtsNAomURskr15nxAzY127C11bPsldA6grWXB5iY8=;
 b=laNs0xaWotINN1VYfODao3FB5L8hJ3O+HXsl1cLuZyOhU5+QgJ7SAHQVzT+W6E6FfqWH
 Dsvwz6FrbrDU9d/aIoesNI4ctd22of+MHBy9V27Zr4u1ukmkRhCpfBwu/OPJU5g5QodG
 PbKjSxnobvXRWxnKEPSnKfGDG16r6KSxftwT0cw4aIdD/YvxCFbaNyTsMO0UjdY7JMLN
 hmPN6ehZsf88VSiJTZviNhEw6io8CmzQLRkxuNFH4jtqBbmerCTzyh0dr+udYF5PVX9K
 fpQsDo3sfoAPy71I2f9QmCmFRV2aQLrqmeanFSvDc8T3bxUcxoD+QTiF6ft8A6qMLahj Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnujufx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 14:29:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NEOOa8102540;
        Wed, 23 Sep 2020 14:29:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33nujpnv7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 14:29:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NEToQO023119;
        Wed, 23 Sep 2020 14:29:50 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 07:29:49 -0700
Date:   Wed, 23 Sep 2020 17:29:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] SVM: nSVM: setup nested msr permission bitmap on
 nested state load
Message-ID: <20200923142943.GL18329@kadam>
References: <20200923134455.GA1485839@mwanda>
 <126ab56ea11b435aedc98ca82a112cf83a60eaf8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126ab56ea11b435aedc98ca82a112cf83a60eaf8.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=909 phishscore=0 adultscore=0 spamscore=0 suspectscore=2
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=2 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=913 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 04:50:58PM +0300, Maxim Levitsky wrote:
> On Wed, 2020-09-23 at 16:44 +0300, Dan Carpenter wrote:
> > Hello Maxim Levitsky,
> > 
> > The patch 772b81bb2f9b: "SVM: nSVM: setup nested msr permission
> > bitmap on nested state load" from Aug 27, 2020, leads to the
> > following static checker warning:
> > 
> > 	arch/x86/kvm/svm/nested.c:1161 svm_set_nested_state()
> > 	warn: 'ctl' not released on lines: 1152.
> > 
> > arch/x86/kvm/svm/nested.c
> >   1135          if (!(save->cr0 & X86_CR0_PG))
> >   1136                  goto out_free;
> >   1137  
> >   1138          /*
> >   1139           * All checks done, we can enter guest mode.  L1 control fields
> >   1140           * come from the nested save state.  Guest state is already
> >   1141           * in the registers, the save area of the nested state instead
> >   1142           * contains saved L1 state.
> >   1143           */
> >   1144          copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> >   1145          hsave->save = *save;
> >   1146  
> >   1147          svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
> >   1148          load_nested_vmcb_control(svm, ctl);
> >   1149          nested_prepare_vmcb_control(svm);
> >   1150  
> >   1151          if (!nested_svm_vmrun_msrpm(svm))
> >   1152                  return -EINVAL;
> > 
> > goto out_free?
> > 
> >   1153  
> >   1154          svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> >   1155  
> >   1156          ret = 0;
> >   1157  out_free:
> >   1158          kfree(save);
> >   1159          kfree(ctl);
> >   1160  
> >   1161          return ret;
> >   1162  }
> > 
> > regards,
> > dan carpenter
> > 
> Which kernel tree is this? 
> 
> This again seems to be the result of other commit
> that made save, ctl to be dynamically allocated. I based my patch on the version
> that allocates both on the stack so no freeing is needed.
> 
> As far as I know from a check I did about week ago, none of branches on 
> git://git.kernel.org/pub/scm/virt/kvm/kvm.git had that patch (that made save/ctr
> be allocated dynamically).

This is from yesterday's linux-next.  Look like a merge issue with
commit 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures
on stack").

regards,
dan carpenter

