Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCBF5F9DB7
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiJJLi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 07:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiJJLiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 07:38:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0766EF31;
        Mon, 10 Oct 2022 04:38:20 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AAqbGF021720;
        Mon, 10 Oct 2022 11:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=S6O5fHkBMWsvsufbHC+ODoDBDUPcjZJwEDIZpUTly8o=;
 b=okuJQ4aDORpv4MPv34J8fWdoGnQiV3xhUOxblmKG7kHOHj4XF7oC6UKPYXU9GqFOqn49
 zUl8QSgjF4e7Tc3wAH6pfozmNXR91SKXY5Ncsp+2z8ND/d42+aNRZ8Ge1YRoefq5L9iG
 16HthD7TIt58gaVKFyRfVwhXHEIXF+J33sNTayFYdCVt9HIRn1746ttTMwACl3hcXm6+
 Qqx7WMLhbBpwhZtFTj9n0maBG3Ctw94HKQCzEV4YxbS3lrx6JzP07jUP2hoBhfrKJVTb
 8saM0O1Nh9eaa56EjGr3aLzWVl2zgRH2i6Ggz9s3CY+V94OcrXretoNRc83zls1gpwzo BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3ju72d3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 11:38:19 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29AAlvYN010358;
        Mon, 10 Oct 2022 11:38:19 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3ju72d32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 11:38:18 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29ABasVs009443;
        Mon, 10 Oct 2022 11:38:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3k30u9a05m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 11:38:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29ABcDlh25559574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 11:38:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDCD011C04C;
        Mon, 10 Oct 2022 11:38:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ED9B11C050;
        Mon, 10 Oct 2022 11:38:13 +0000 (GMT)
Received: from [9.171.5.210] (unknown [9.171.5.210])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 11:38:13 +0000 (GMT)
Message-ID: <577ff026-949e-4c03-39c6-1e33edae0f16@linux.ibm.com>
Date:   Mon, 10 Oct 2022 13:38:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v14 1/6] KVM: s390: pv: asynchronous destroy for reboot
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-2-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220930140150.37463-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NB8pUlyRzWDpPdt271XT1_mkLX-3HdSG
X-Proofpoint-ORIG-GUID: hPFNEKS-ue8JarCen9F2VjD9Ha6MAKEM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_06,2022-10-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 clxscore=1011 mlxscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100067
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/30/22 16:01, Claudio Imbrenda wrote:
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
> 
> This patch implements an asynchronous destroy mechanism, that allows a
> protected guest to reboot significantly faster than previously.
> 
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
> 
> The old protected guest is then only destroyed when all of its memory
> has been destroyed or otherwise made non protected.
> 
> Two new PV commands are added for the KVM_S390_PV_COMMAND ioctl:
> 
> KVM_PV_ASYNC_CLEANUP_PREPARE: set aside the current protected VM for
> later asynchronous teardown. The current KVM VM will then continue
> immediately as non-protected. If a protected VM had already been
> set aside for asynchronous teardown, but without starting the teardown
> process, this call will fail. There can be at most one VM set aside at
> any time. Once it is set aside, the protected VM only exists in the
> context of the Ultravisor, it is not associated with the KVM VM
> anymore. Its protected CPUs have already been destroyed, but not its
> memory. This command can be issued again immediately after starting
> KVM_PV_ASYNC_CLEANUP_PERFORM, without having to wait for completion.
> 
> KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
> set aside using KVM_PV_ASYNC_CLEANUP_PREPARE. Ideally the
> KVM_PV_ASYNC_CLEANUP_PERFORM PV command should be issued by userspace
> from a separate thread. If a fatal signal is received (or if the
> process terminates naturally), the command will terminate immediately
> without completing. All protected VMs whose teardown was interrupted
> will be put in the need_cleanup list. The rest of the normal KVM
> teardown process will take care of properly cleaning up all remaining
> protected VMs, including the ones on the need_cleanup list.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

That was quite a read.

With Steffen's nits fixed:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
