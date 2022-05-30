Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FA5537827
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiE3Jqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiE3Jqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:46:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D245D1F8;
        Mon, 30 May 2022 02:46:33 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U93Xbs031806;
        Mon, 30 May 2022 09:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=apVMKSEu3+c8cSIa+J7x/qxcIBqSkTjcAftQlSQ/mnM=;
 b=r5dkp2oB5dlSnqe7TVDtV3ExCCEDXoxQXRO4YeaQnvdIqvG7Npia4rIcmvtPDAOLKNGc
 Pt0I50RmkQgSuzP/av7JQpdz40zzSX5vuMGFD0/8+tmLSdFeCuPfcNFf3gm7gAEPFuFz
 +ljpioVlQafKRxv5EQpVBNoDq7fPpcQPOrUuhJpoBrg7fcRxbbaX/Z6TaIqjFHRG6fNv
 6Z4nP7Mtigy8iXHSGEeXmFXFLWqSbQm3Ny3HWISEV58NbcSTq3IHPUF0bsOyF5DtgNEc
 TNn9RuuyRrswTqCaILHqCyj+rc5dAwv77qm1/wsXblBcIYNXo58VdlBsx0I8a7sy+u13 xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcty78t09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:46:32 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U9VF55017637;
        Mon, 30 May 2022 09:46:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcty78syu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:46:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U9axJD018194;
        Mon, 30 May 2022 09:46:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3gbcc69umy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:46:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U9W79855837142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 09:32:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E626EAE051;
        Mon, 30 May 2022 09:46:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 779DAAE045;
        Mon, 30 May 2022 09:46:26 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 09:46:26 +0000 (GMT)
Message-ID: <49c2667ecfc2c628c13cae79796ffac4ddc2c0c3.camel@linux.ibm.com>
Subject: Re: [PATCH v10 15/19] KVM: s390: pv: asynchronous destroy for reboot
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 30 May 2022 11:46:26 +0200
In-Reply-To: <20220414080311.1084834-16-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-16-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jPXnunXG_P-bggrCcCuqZUbKi4yvWZqQ
X-Proofpoint-GUID: -EpW3T9QejJq_UMEupMBV9vPTKv5zgYv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501 mlxlogscore=944
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205300050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
[...]
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index b20f2cbd43d9..36bc107bbd7d 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
[...]
> +/**
> + * kvm_s390_pv_deinit_vm_async - Perform an asynchronous teardown of
> a
> + * protected VM.
> + * @kvm the VM previously associated with the protected VM
> + * @rc return value for the RC field of the UVCB
> + * @rrc return value for the RRC field of the UVCB
> + *
> + * Tear down the protected VM that had previously been set aside
> using
> + * kvm_s390_pv_deinit_vm_async_prepare.
> + *
> + * Context: kvm->lock needs to be held

...and will be released...

> + *
> + * Return: 0 in case of success, -EINVAL if no protected VM had been
> + * prepared for asynchronous teardowm, -EIO in case of other errors.
> + */
> +int kvm_s390_pv_deinit_vm_async(struct kvm *kvm, u16 *rc, u16 *rrc)

Do you also want to set rc and rrc as in kvm_s390_pv_deinit_vm_async_prepar=
e()?

