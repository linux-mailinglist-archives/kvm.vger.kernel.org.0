Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988EF609BEB
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 09:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJXH51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 03:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiJXH5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 03:57:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D5A5D0CA;
        Mon, 24 Oct 2022 00:57:17 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O7rSaW022223;
        Mon, 24 Oct 2022 07:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vRy4JKi2hiTPU6DEDzc32msUDXB+qNaYLMEsipZS9SY=;
 b=EY31qLY/PqBufnOGMFbpjWZmdhz0XxXOZx1N/aTcfgxBgZ83qR+/D7wryNRpm4bf31bD
 ZF+JI/ZvhrJ18BUESG4K0ocOzkfgJx2EcQFotwMjtikMXaqmj1ZX7Ajymn1Q5TBqXvJQ
 +pxMW6KAccFjU7JbgDIWy49PEfdj8p4fUlISZSE4YnweaCDjzvEe55Vpm2BDQtr8e8d4
 aogXfFF+/oioUQA7JzcvtluXe9e631wxU9V2KLNtwzVxnL3bRvpzHlJCN/EXwjEAzWD3
 MMp3+knyRbf8G2kz9wBgkuvxrUt4bhf5H/SYuPW0xJ56VfCnUVqU+BByn3Ix3D4bGbiV WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdpq2g340-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 07:56:37 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29O7t3In027839;
        Mon, 24 Oct 2022 07:56:36 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdpq2g338-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 07:56:36 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29O7pRxM029295;
        Mon, 24 Oct 2022 07:56:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3kc85925uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 07:56:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29O7uWT42556580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 07:56:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66A854203F;
        Mon, 24 Oct 2022 07:56:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9BF642042;
        Mon, 24 Oct 2022 07:56:31 +0000 (GMT)
Received: from [9.171.39.85] (unknown [9.171.39.85])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Oct 2022 07:56:31 +0000 (GMT)
Message-ID: <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
Date:   Mon, 24 Oct 2022 09:56:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/4] KVM: API to block and resume all running vcpus in a
 vm
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221022154819.1823133-1-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: twODhqbGT2UU-N8Mp1M7h0N9oMDxLJZl
X-Proofpoint-ORIG-GUID: pQs1VJ42LLQhwKBIkWJY-SPS8htoU3jF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_01,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=783 adultscore=0 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 22.10.22 um 17:48 schrieb Emanuele Giuseppe Esposito:
> This new API allows the userspace to stop all running
> vcpus using KVM_KICK_ALL_RUNNING_VCPUS ioctl, and resume them with
> KVM_RESUME_ALL_KICKED_VCPUS.
> A "running" vcpu is a vcpu that is executing the KVM_RUN ioctl.
> 
> This serie is especially helpful to userspace hypervisors like
> QEMU when they need to perform operations on memslots without the
> risk of having a vcpu reading them in the meanwhile.
> With "memslots operations" we mean grow, shrink, merge and split
> memslots, which are not "atomic" because there is a time window
> between the DELETE memslot operation and the CREATE one.
> Currently, each memslot operation is performed with one or more
> ioctls.
> For example, merging two memslots into one would imply:
> DELETE(m1)
> DELETE(m2)
> CREATE(m1+m2)
> 
> And a vcpu could attempt to read m2 right after it is deleted, but
> before the new one is created.
> 
> Therefore the simplest solution is to pause all vcpus in the kvm
> side, so that:
> - userspace just needs to call the new API before making memslots
> changes, keeping modifications to the minimum
> - dirty page updates are also performed when vcpus are blocked, so
> there is no time window between the dirty page ioctl and memslots
> modifications, since vcpus are all stopped.
> - no need to modify the existing memslots API
Isnt QEMU able to achieve the same goal today by forcing all vCPUs
into userspace with a signal? Can you provide some rationale why this
is better in the cover letter or patch description?
