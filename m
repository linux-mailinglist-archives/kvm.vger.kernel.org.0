Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B19518C645
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 05:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCTEJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 00:09:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59941 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbgCTEJa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 00:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584677368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTP5uCyJlvuviLn9RaJ33fI2vBabW0JvBvFnhj1k++E=;
        b=RvKNg1oumnhiXPeMQrSVBfskliYg99LmrYIS4OIpHN1MydT2RR6hhekiVJiPpiOu0dB/Uw
        svylP1rcaBC9xcWeW8MOiExDv1EKUTs2JYXK5do8DmpzdmMUP8pKlQk/br3Jh2uwEk2dxe
        gJ7+kszOvbY1A6VYBkXNk3AB+9e1U7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-JtSLeZ3hPsa1hZFgVxufEQ-1; Fri, 20 Mar 2020 00:09:24 -0400
X-MC-Unique: JtSLeZ3hPsa1hZFgVxufEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0B7E1857BE3;
        Fri, 20 Mar 2020 04:09:21 +0000 (UTC)
Received: from x1.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5931038F;
        Fri, 20 Mar 2020 04:09:19 +0000 (UTC)
Date:   Thu, 19 Mar 2020 22:09:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 1/7] vfio: KABI for migration interface for
 device state
Message-ID: <20200319220918.3da0d856@x1.home>
In-Reply-To: <20200320030656.GK4641@joy-OptiPlex-7040>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-2-git-send-email-kwankhede@nvidia.com>
        <20200319011703.GC4641@joy-OptiPlex-7040>
        <20200318214926.5a0157e5@w520.home>
        <20200319050554.GF4641@joy-OptiPlex-7040>
        <20200319070921.565177ca@x1.home>
        <20200320013039.GJ4641@joy-OptiPlex-7040>
        <20200319203440.1245afd7@x1.home>
        <20200320030656.GK4641@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 23:06:56 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Mar 20, 2020 at 10:34:40AM +0800, Alex Williamson wrote:
> > On Thu, 19 Mar 2020 21:30:39 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Thu, Mar 19, 2020 at 09:09:21PM +0800, Alex Williamson wrote:  
> > > > On Thu, 19 Mar 2020 01:05:54 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > On Thu, Mar 19, 2020 at 11:49:26AM +0800, Alex Williamson wrote:    
> > > > > > On Wed, 18 Mar 2020 21:17:03 -0400
> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >       
> > > > > > > On Thu, Mar 19, 2020 at 03:41:08AM +0800, Kirti Wankhede wrote:      
> > > > > > > > - Defined MIGRATION region type and sub-type.
> > > > > > > > 
> > > > > > > > - Defined vfio_device_migration_info structure which will be placed at the
> > > > > > > >   0th offset of migration region to get/set VFIO device related
> > > > > > > >   information. Defined members of structure and usage on read/write access.
> > > > > > > > 
> > > > > > > > - Defined device states and state transition details.
> > > > > > > > 
> > > > > > > > - Defined sequence to be followed while saving and resuming VFIO device.
> > > > > > > > 
> > > > > > > > Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > > > > > > > Reviewed-by: Neo Jia <cjia@nvidia.com>
> > > > > > > > ---
> > > > > > > >  include/uapi/linux/vfio.h | 227 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > > > >  1 file changed, 227 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > > > > > index 9e843a147ead..d0021467af53 100644
> > > > > > > > --- a/include/uapi/linux/vfio.h
> > > > > > > > +++ b/include/uapi/linux/vfio.h
> > > > > > > > @@ -305,6 +305,7 @@ struct vfio_region_info_cap_type {
> > > > > > > >  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> > > > > > > >  #define VFIO_REGION_TYPE_GFX                    (1)
> > > > > > > >  #define VFIO_REGION_TYPE_CCW			(2)
> > > > > > > > +#define VFIO_REGION_TYPE_MIGRATION              (3)
> > > > > > > >  
> > > > > > > >  /* sub-types for VFIO_REGION_TYPE_PCI_* */
> > > > > > > >  
> > > > > > > > @@ -379,6 +380,232 @@ struct vfio_region_gfx_edid {
> > > > > > > >  /* sub-types for VFIO_REGION_TYPE_CCW */
> > > > > > > >  #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
> > > > > > > >  
> > > > > > > > +/* sub-types for VFIO_REGION_TYPE_MIGRATION */
> > > > > > > > +#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * The structure vfio_device_migration_info is placed at the 0th offset of
> > > > > > > > + * the VFIO_REGION_SUBTYPE_MIGRATION region to get and set VFIO device related
> > > > > > > > + * migration information. Field accesses from this structure are only supported
> > > > > > > > + * at their native width and alignment. Otherwise, the result is undefined and
> > > > > > > > + * vendor drivers should return an error.
> > > > > > > > + *
> > > > > > > > + * device_state: (read/write)
> > > > > > > > + *      - The user application writes to this field to inform the vendor driver
> > > > > > > > + *        about the device state to be transitioned to.
> > > > > > > > + *      - The vendor driver should take the necessary actions to change the
> > > > > > > > + *        device state. After successful transition to a given state, the
> > > > > > > > + *        vendor driver should return success on write(device_state, state)
> > > > > > > > + *        system call. If the device state transition fails, the vendor driver
> > > > > > > > + *        should return an appropriate -errno for the fault condition.
> > > > > > > > + *      - On the user application side, if the device state transition fails,
> > > > > > > > + *	  that is, if write(device_state, state) returns an error, read
> > > > > > > > + *	  device_state again to determine the current state of the device from
> > > > > > > > + *	  the vendor driver.
> > > > > > > > + *      - The vendor driver should return previous state of the device unless
> > > > > > > > + *        the vendor driver has encountered an internal error, in which case
> > > > > > > > + *        the vendor driver may report the device_state VFIO_DEVICE_STATE_ERROR.
> > > > > > > > + *      - The user application must use the device reset ioctl to recover the
> > > > > > > > + *        device from VFIO_DEVICE_STATE_ERROR state. If the device is
> > > > > > > > + *        indicated to be in a valid device state by reading device_state, the
> > > > > > > > + *        user application may attempt to transition the device to any valid
> > > > > > > > + *        state reachable from the current state or terminate itself.
> > > > > > > > + *
> > > > > > > > + *      device_state consists of 3 bits:
> > > > > > > > + *      - If bit 0 is set, it indicates the _RUNNING state. If bit 0 is clear,
> > > > > > > > + *        it indicates the _STOP state. When the device state is changed to
> > > > > > > > + *        _STOP, driver should stop the device before write() returns.
> > > > > > > > + *      - If bit 1 is set, it indicates the _SAVING state, which means that the
> > > > > > > > + *        driver should start gathering device state information that will be
> > > > > > > > + *        provided to the VFIO user application to save the device's state.
> > > > > > > > + *      - If bit 2 is set, it indicates the _RESUMING state, which means that
> > > > > > > > + *        the driver should prepare to resume the device. Data provided through
> > > > > > > > + *        the migration region should be used to resume the device.
> > > > > > > > + *      Bits 3 - 31 are reserved for future use. To preserve them, the user
> > > > > > > > + *      application should perform a read-modify-write operation on this
> > > > > > > > + *      field when modifying the specified bits.
> > > > > > > > + *
> > > > > > > > + *  +------- _RESUMING
> > > > > > > > + *  |+------ _SAVING
> > > > > > > > + *  ||+----- _RUNNING
> > > > > > > > + *  |||
> > > > > > > > + *  000b => Device Stopped, not saving or resuming
> > > > > > > > + *  001b => Device running, which is the default state
> > > > > > > > + *  010b => Stop the device & save the device state, stop-and-copy state
> > > > > > > > + *  011b => Device running and save the device state, pre-copy state
> > > > > > > > + *  100b => Device stopped and the device state is resuming
> > > > > > > > + *  101b => Invalid state
> > > > > > > > + *  110b => Error state
> > > > > > > > + *  111b => Invalid state
> > > > > > > > + *
> > > > > > > > + * State transitions:
> > > > > > > > + *
> > > > > > > > + *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> > > > > > > > + *                (100b)     (001b)     (011b)        (010b)       (000b)
> > > > > > > > + * 0. Running or default state
> > > > > > > > + *                             |
> > > > > > > > + *
> > > > > > > > + * 1. Normal Shutdown (optional)
> > > > > > > > + *                             |------------------------------------->|
> > > > > > > > + *
> > > > > > > > + * 2. Save the state or suspend
> > > > > > > > + *                             |------------------------->|---------->|
> > > > > > > > + *
> > > > > > > > + * 3. Save the state during live migration
> > > > > > > > + *                             |----------->|------------>|---------->|
> > > > > > > > + *
> > > > > > > > + * 4. Resuming
> > > > > > > > + *                  |<---------|
> > > > > > > > + *
> > > > > > > > + * 5. Resumed
> > > > > > > > + *                  |--------->|
> > > > > > > > + *
> > > > > > > > + * 0. Default state of VFIO device is _RUNNNG when the user application starts.
> > > > > > > > + * 1. During normal shutdown of the user application, the user application may
> > > > > > > > + *    optionally change the VFIO device state from _RUNNING to _STOP. This
> > > > > > > > + *    transition is optional. The vendor driver must support this transition but
> > > > > > > > + *    must not require it.
> > > > > > > > + * 2. When the user application saves state or suspends the application, the
> > > > > > > > + *    device state transitions from _RUNNING to stop-and-copy and then to _STOP.
> > > > > > > > + *    On state transition from _RUNNING to stop-and-copy, driver must stop the
> > > > > > > > + *    device, save the device state and send it to the application through the
> > > > > > > > + *    migration region. The sequence to be followed for such transition is given
> > > > > > > > + *    below.
> > > > > > > > + * 3. In live migration of user application, the state transitions from _RUNNING
> > > > > > > > + *    to pre-copy, to stop-and-copy, and to _STOP.
> > > > > > > > + *    On state transition from _RUNNING to pre-copy, the driver should start
> > > > > > > > + *    gathering the device state while the application is still running and send
> > > > > > > > + *    the device state data to application through the migration region.
> > > > > > > > + *    On state transition from pre-copy to stop-and-copy, the driver must stop
> > > > > > > > + *    the device, save the device state and send it to the user application
> > > > > > > > + *    through the migration region.
> > > > > > > > + *    Vendor drivers must support the pre-copy state even for implementations
> > > > > > > > + *    where no data is provided to the user before the stop-and-copy state. The
> > > > > > > > + *    user must not be required to consume all migration data before the device
> > > > > > > > + *    transitions to a new state, including the stop-and-copy state.
> > > > > > > > + *    The sequence to be followed for above two transitions is given below.
> > > > > > > > + * 4. To start the resuming phase, the device state should be transitioned from
> > > > > > > > + *    the _RUNNING to the _RESUMING state.
> > > > > > > > + *    In the _RESUMING state, the driver should use the device state data
> > > > > > > > + *    received through the migration region to resume the device.
> > > > > > > > + * 5. After providing saved device data to the driver, the application should
> > > > > > > > + *    change the state from _RESUMING to _RUNNING.
> > > > > > > > + *
> > > > > > > > + * reserved:
> > > > > > > > + *      Reads on this field return zero and writes are ignored.
> > > > > > > > + *
> > > > > > > > + * pending_bytes: (read only)
> > > > > > > > + *      The number of pending bytes still to be migrated from the vendor driver.
> > > > > > > > + *
> > > > > > > > + * data_offset: (read only)
> > > > > > > > + *      The user application should read data_offset in the migration region
> > > > > > > > + *      from where the user application should read the device data during the
> > > > > > > > + *      _SAVING state or write the device data during the _RESUMING state. See
> > > > > > > > + *      below for details of sequence to be followed.
> > > > > > > > + *
> > > > > > > > + * data_size: (read/write)
> > > > > > > > + *      The user application should read data_size to get the size in bytes of
> > > > > > > > + *      the data copied in the migration region during the _SAVING state and
> > > > > > > > + *      write the size in bytes of the data copied in the migration region
> > > > > > > > + *      during the _RESUMING state.
> > > > > > > > + *
> > > > > > > > + * The format of the migration region is as follows:
> > > > > > > > + *  ------------------------------------------------------------------
> > > > > > > > + * |vfio_device_migration_info|    data section                      |
> > > > > > > > + * |                          |     ///////////////////////////////  |
> > > > > > > > + * ------------------------------------------------------------------
> > > > > > > > + *   ^                              ^
> > > > > > > > + *  offset 0-trapped part        data_offset
> > > > > > > > + *
> > > > > > > > + * The structure vfio_device_migration_info is always followed by the data
> > > > > > > > + * section in the region, so data_offset will always be nonzero. The offset
> > > > > > > > + * from where the data is copied is decided by the kernel driver. The data
> > > > > > > > + * section can be trapped, mapped, or partitioned, depending on how the kernel
> > > > > > > > + * driver defines the data section. The data section partition can be defined
> > > > > > > > + * as mapped by the sparse mmap capability. If mmapped, data_offset should be
> > > > > > > > + * page aligned, whereas initial section which contains the
> > > > > > > > + * vfio_device_migration_info structure, might not end at the offset, which is
> > > > > > > > + * page aligned. The user is not required to access through mmap regardless
> > > > > > > > + * of the capabilities of the region mmap.
> > > > > > > > + * The vendor driver should determine whether and how to partition the data
> > > > > > > > + * section. The vendor driver should return data_offset accordingly.
> > > > > > > > + *
> > > > > > > > + * The sequence to be followed for the _SAVING|_RUNNING device state or
> > > > > > > > + * pre-copy phase and for the _SAVING device state or stop-and-copy phase is as
> > > > > > > > + * follows:
> > > > > > > > + * a. Read pending_bytes, indicating the start of a new iteration to get device
> > > > > > > > + *    data. Repeated read on pending_bytes at this stage should have no side
> > > > > > > > + *    effects.
> > > > > > > > + *    If pending_bytes == 0, the user application should not iterate to get data
> > > > > > > > + *    for that device.
> > > > > > > > + *    If pending_bytes > 0, perform the following steps.
> > > > > > > > + * b. Read data_offset, indicating that the vendor driver should make data
> > > > > > > > + *    available through the data section. The vendor driver should return this
> > > > > > > > + *    read operation only after data is available from (region + data_offset)
> > > > > > > > + *    to (region + data_offset + data_size).
> > > > > > > > + * c. Read data_size, which is the amount of data in bytes available through
> > > > > > > > + *    the migration region.
> > > > > > > > + *    Read on data_offset and data_size should return the offset and size of
> > > > > > > > + *    the current buffer if the user application reads data_offset and
> > > > > > > > + *    data_size more than once here.        
> > > > > > > If data region is mmaped, merely reading data_offset and data_size
> > > > > > > cannot let kernel know what are correct values to return.
> > > > > > > Consider to add a read operation which is trapped into kernel to let
> > > > > > > kernel exactly know it needs to move to the next offset and update data_size
> > > > > > > ?      
> > > > > > 
> > > > > > Both operations b. and c. above are to trapped registers, operation d.
> > > > > > below may potentially be to an mmap'd area, which is why we have step
> > > > > > f. which indicates to the vendor driver that the data has been
> > > > > > consumed.  Does that address your concern?  Thanks,
> > > > > >      
> > > > > No. :)
> > > > > the problem is about semantics of data_offset, data_size, and
> > > > > pending_bytes.
> > > > > b and c do not tell kernel that the data is read by user.
> > > > > so, without knowing step d happen, kernel cannot update pending_bytes to
> > > > > be returned in step f.    
> > > > 
> > > > Sorry, I'm still not understanding, I see step f. as the indicator
> > > > you're looking for.  The user reads pending_bytes to indicate the data
> > > > in the migration area has been consumed.  The vendor driver updates its
> > > > internal state on that read and returns the updated value for
> > > > pending_bytes.  Thanks,
> > > >     
> > > we could not regard reading of pending_bytes as an indicator of
> > > migration data consumed.
> > > 
> > > for 1, in migration thread, read of pending_bytes is called every
> > > iteration, but reads of data_size & data_offset are not (they are
> > > skippable). so it's possible that the sequence is like
> > > (1) reading of pending_bytes
> > > (2) reading of pending_bytes
> > > (3) reading of pending_bytes
> > > (4) reading of data_offset & data_size
> > > (5) reading of pending_bytes
> > > 
> > > for 2, it's not right to force kernel to understand qemu's sequence and
> > > decide that only a read of pending_bytes after reads of data_offset & data_size
> > > indicates data has been consumed.
> > > 
> > > Agree?  
> > 
> > No, not really.  We're defining an API that enables the above sequence,
> > but doesn't require the kernel to understand QEMU's sequence.
> > Specifically, pending_bytes may be read without side-effects except for
> > when data is queued to read through the data area of the region.  The
> > user queues data to read by reading data_offset.  The user then reads
> > data_size to determine the currently available data chunk size.  This
> > is followed by consuming the data from the region offset + data_offset.
> > Only after reading data_offset does the read of pending_bytes signal to
> > the vendor driver that the user has consumed the data.
> > 
> > If the user were to re-read pending_bytes before consuming the data,
> > then the data_offset and data_size they may have read is invalid and
> > they've violated the defined protocol.  We do not, nor do I think we
> > could, make this a fool proof interface.  The user must adhere to the
> > protocol, but I believe the specific sequence you've identified is
> > fully enabled here.  Please confirm.  Thanks,
> >   
>  c. Read data_size, which is the amount of data in bytes available through
>   the migration region.
>   Read on data_offset and data_size should return the offset and size of
>   the current buffer if the user application reads data_offset and
>   data_size more than once here.      
> 
> so, if the sequence is like this:
>  (1) reading of pending_bytes
>  (2) reading of data_offset & data_size
>  (3) reading of data_offset & data_size
>  (4) reading of data_offset & data_size
>  (5) reading of pending_bytes
> (2)-(4) should return the same values (and different values are allowed)
> In step (5), pending_bytes should be the value in step (1) - data_size in
> step (4).
> 
> Is this understanding right?

I believe that's correct except the user cannot presume the next value
of pending_bytes, the device might have generated more state between
steps (1) and (5).  If the device is stopped, this might be a
reasonable assumption, but the protocol is to rely on the device
reported pending_bytes rather than calculate.  The user is required to
read_pending bytes to increment to the next data chunk anyway.  Thanks,

Alex

> > > > > > > > + * d. Read data_size bytes of data from (region + data_offset) from the
> > > > > > > > + *    migration region.
> > > > > > > > + * e. Process the data.
> > > > > > > > + * f. Read pending_bytes, which indicates that the data from the previous
> > > > > > > > + *    iteration has been read. If pending_bytes > 0, go to step b.
> > > > > > > > + *
> > > > > > > > + * If an error occurs during the above sequence, the vendor driver can return
> > > > > > > > + * an error code for next read() or write() operation, which will terminate the
> > > > > > > > + * loop. The user application should then take the next necessary action, for
> > > > > > > > + * example, failing migration or terminating the user application.
> > > > > > > > + *
> > > > > > > > + * The user application can transition from the _SAVING|_RUNNING
> > > > > > > > + * (pre-copy state) to the _SAVING (stop-and-copy) state regardless of the
> > > > > > > > + * number of pending bytes. The user application should iterate in _SAVING
> > > > > > > > + * (stop-and-copy) until pending_bytes is 0.
> > > > > > > > + *
> > > > > > > > + * The sequence to be followed while _RESUMING device state is as follows:
> > > > > > > > + * While data for this device is available, repeat the following steps:
> > > > > > > > + * a. Read data_offset from where the user application should write data.
> > > > > > > > + * b. Write migration data starting at the migration region + data_offset for
> > > > > > > > + *    the length determined by data_size from the migration source.
> > > > > > > > + * c. Write data_size, which indicates to the vendor driver that data is
> > > > > > > > + *    written in the migration region. Vendor driver should apply the
> > > > > > > > + *    user-provided migration region data to the device resume state.
> > > > > > > > + *
> > > > > > > > + * For the user application, data is opaque. The user application should write
> > > > > > > > + * data in the same order as the data is received and the data should be of
> > > > > > > > + * same transaction size at the source.
> > > > > > > > + */
> > > > > > > > +
> > > > > > > > +struct vfio_device_migration_info {
> > > > > > > > +	__u32 device_state;         /* VFIO device state */
> > > > > > > > +#define VFIO_DEVICE_STATE_STOP      (0)
> > > > > > > > +#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> > > > > > > > +#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> > > > > > > > +#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> > > > > > > > +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> > > > > > > > +				     VFIO_DEVICE_STATE_SAVING |  \
> > > > > > > > +				     VFIO_DEVICE_STATE_RESUMING)
> > > > > > > > +
> > > > > > > > +#define VFIO_DEVICE_STATE_VALID(state) \
> > > > > > > > +	(state & VFIO_DEVICE_STATE_RESUMING ? \
> > > > > > > > +	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
> > > > > > > > +
> > > > > > > > +#define VFIO_DEVICE_STATE_IS_ERROR(state) \
> > > > > > > > +	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
> > > > > > > > +					      VFIO_DEVICE_STATE_RESUMING))
> > > > > > > > +
> > > > > > > > +#define VFIO_DEVICE_STATE_SET_ERROR(state) \
> > > > > > > > +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> > > > > > > > +					     VFIO_DEVICE_STATE_RESUMING)
> > > > > > > > +
> > > > > > > > +	__u32 reserved;
> > > > > > > > +	__u64 pending_bytes;
> > > > > > > > +	__u64 data_offset;
> > > > > > > > +	__u64 data_size;
> > > > > > > > +} __attribute__((packed));
> > > > > > > > +
> > > > > > > >  /*
> > > > > > > >   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
> > > > > > > >   * which allows direct access to non-MSIX registers which happened to be within
> > > > > > > > -- 
> > > > > > > > 2.7.0
> > > > > > > >         
> > > > > > >       
> > > > > >       
> > > > >     
> > > >     
> > >   
> >   
> 

